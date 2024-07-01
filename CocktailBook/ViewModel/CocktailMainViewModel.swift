//
//  CocktailMainViewModel.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import Combine
import SwiftUI
import CocktailsAPI

class CocktailMainViewModel: ObservableObject {
    
    static let callFailureCount: UInt = 2
    
    @Published var cocktails: [Cocktail] = []
    @Published var filteredCocktails: [Cocktail] = []
    @Published var favorites: Set<String> = []
    @Published var cocktailType: CocktailType = .all
    @Published var isLoading = false
    @Published var showErrorAlert = false
    var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let cocktailsAPI: CocktailsAPI
    private var favoritesRepository: FavoritesRepository
    
    enum CocktailType: String, CaseIterable {
        case all = ""
        case alcoholic = "alcoholic"
        case nonAlcoholic = "non-alcoholic"

        func getPickerTitle() -> String {
            switch self {
            case .all:
                return "All"
            case .alcoholic:
                return "Alcoholic"
            case .nonAlcoholic:
                return "Non-Alcoholic"
            }
        }
    }
    
    init(cocktailsAPI: CocktailsAPI, favoritesRepository: FavoritesRepository) {
        self.cocktailsAPI = cocktailsAPI
        self.favoritesRepository = favoritesRepository
        self.favorites = self.favoritesRepository.favorites
        bind()
        fetchCocktails()
    }
    
    func onFavoriteToggle(_ cocktail: Cocktail) {
        let cocktailID = cocktail.id
        if favorites.contains(cocktailID) {
            favoritesRepository.removeFavorite(cocktailID)
        } else {
            favoritesRepository.addFavorite(cocktailID)
        }
        favorites = favoritesRepository.favorites
        sortFilteredCocktails()
    }
    
    var navigationTitle: String {
        switch cocktailType {
        case .all:
            return "All Cocktails"
        case .alcoholic:
            return "Alcoholic Cocktails"
        case .nonAlcoholic:
            return "Non-Alcoholic Cocktails"
        }
    }
    
    func tryAgainFethcingCocktails() {
        fetchCocktails()
    }
    
    private func fetchCocktails() {
        isLoading = true
        cocktailsAPI.cocktailsPublisher
            .map { data in
                try? JSONDecoder().decode([Cocktail].self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleFetchCompletion(completion)
            }, receiveValue: { [weak self] cocktails in
                self?.handleFetchedCocktails(cocktails)
            })
            .store(in: &cancellables)
    }
    
    private func handleFetchCompletion(_ completion: Subscribers.Completion<CocktailsAPIError>) {
        isLoading = false
        switch completion {
        case .finished:
            errorMessage = ""
            showErrorAlert = false
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleFetchedCocktails(_ cocktails: [Cocktail]?) {
        self.cocktails = cocktails ?? []
        applyFilter()
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
    
    private func bind() {
        $cocktailType
            .sink { [weak self] _ in
                self?.fetchCocktails()
            }
            .store(in: &cancellables)
    }
    
    private func applyFilter() {
        switch cocktailType {
        case .all:
            filteredCocktails = cocktails
        case .alcoholic:
            filteredCocktails = cocktails.filter { $0.type == CocktailType.alcoholic.rawValue }
        case .nonAlcoholic:
            filteredCocktails = cocktails.filter { $0.type == CocktailType.nonAlcoholic.rawValue }
        }
        sortFilteredCocktails()
    }
    
    private func sortFilteredCocktails() {
        filteredCocktails.sort { $0.name < $1.name }
        updateFavoriteStatus()
    }
    
    private func updateFavoriteStatus() {
        for index in filteredCocktails.indices {
            filteredCocktails[index].isFavorite = favorites.contains(filteredCocktails[index].id)
        }
        let favoriteCocktails = filteredCocktails.filter { favorites.contains($0.id) }
        let nonFavoriteCocktails = filteredCocktails.filter { !favorites.contains($0.id) }
        filteredCocktails = favoriteCocktails + nonFavoriteCocktails
    }
    
}
