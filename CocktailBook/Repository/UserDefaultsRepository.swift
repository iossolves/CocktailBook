//
//  UserDefaultsRepository.swift
//  CocktailBook
//
//  Created by Karunakar on 18/06/24.
//

import Foundation

class UserDefaultsRepository: FavoritesRepository {
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteCockTails"
    
    var favorites: Set<String> {
        get {
            guard let favorites = userDefaults.array(forKey: favoritesKey) as? [String] else {
                return []
            }
            return Set(favorites)
        }
        set {
            userDefaults.set(Array(newValue), forKey: favoritesKey)
        }
    }
    
    func addFavorite(_ favoriteID: String) {
        var currentFavorites = favorites
        currentFavorites.insert(favoriteID)
        favorites = currentFavorites
    }
    
    func removeFavorite(_ favoriteID: String) {
        var currentFavorites = favorites
        currentFavorites.remove(favoriteID)
        favorites = currentFavorites
    }
    
    func isFavorite(_ favoriteID: String) -> Bool {
        return favorites.contains(favoriteID)
    }
}
