//
//  CocktailDetailViewModel.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import Foundation

class CocktailDetailViewModel: ObservableObject {
    @Published var cocktail: Cocktail
    let onFavoriteToggle: ((Cocktail) -> Void)?

    init(cocktail: Cocktail, onFavoriteToggle: ((Cocktail) -> Void)? = nil) {
        self.cocktail = cocktail
        self.onFavoriteToggle = onFavoriteToggle
    }

    func toggleFavorite() {
        cocktail.isFavorite.toggle()
        onFavoriteToggle?(cocktail)
    }
    
    var isFavorite: Bool {
        cocktail.isFavorite
    }
}
