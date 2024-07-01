//
//  FavoritesRepository.swift
//  CocktailBook
//
//  Created by Karunakar on 18/06/24.
//

import Foundation

protocol FavoritesRepository {
    var favorites: Set<String> { get set }
    
    func addFavorite(_ favoriteID: String)
    func removeFavorite(_ favoriteID: String)
    func isFavorite(_ favoriteID: String) -> Bool
}
