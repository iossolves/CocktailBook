//
//  CocktailDetailViewModelTests.swift
//  CocktailBookTests
//
//  Created by Nandana Bandikatla on 20/06/24.
//

import XCTest
import CocktailsAPI

@testable import CocktailBook

class CocktailDetailViewModelTests: XCTestCase {

    func testToggleFavorite() {
        let mockCocktail = Cocktail(id: "1", name: "Mojito", type: "alcoholic")
        var favoriteToggled = false
        let mockOnFavoriteToggle: ((Cocktail) -> Void) = { cocktail in
            favoriteToggled = true
            XCTAssertEqual(cocktail.isFavorite, !mockCocktail.isFavorite)
        }
        
        let viewModel = CocktailDetailViewModel(cocktail: mockCocktail, onFavoriteToggle: mockOnFavoriteToggle)
        viewModel.toggleFavorite()
        
        XCTAssertEqual(viewModel.isFavorite, true)
        XCTAssertTrue(favoriteToggled)
    }
    
    func testIsFavorite() {
        let mockCocktail = Cocktail(id: "2", name: "Cosmopolitan", type: "alcoholic")
        let viewModel = CocktailDetailViewModel(cocktail: mockCocktail)
        XCTAssertFalse(viewModel.isFavorite)
    }
}
