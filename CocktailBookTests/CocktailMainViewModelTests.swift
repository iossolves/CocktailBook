//
//  File.swift
//  CocktailBookTests
//
//  Created by Karunakar on 20/06/24.
//

import XCTest
import Combine
import CocktailsAPI

@testable import CocktailBook

class CocktailMainViewModelTests: XCTestCase {
    
    var viewModel: CocktailMainViewModel!
    var mockAPI: FakeCocktailsAPI!
    var mockFavoritesRepository: UserDefaultsRepository!
    
    override func setUp() {
        super.setUp()
        
        // Initialize mock dependencies
        mockAPI = FakeCocktailsAPI()
        mockFavoritesRepository = UserDefaultsRepository()
        
        // Initialize the view model with mocks
        viewModel = CocktailMainViewModel(
            cocktailsAPI: mockAPI,
            favoritesRepository: mockFavoritesRepository
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        mockFavoritesRepository = nil
        super.tearDown()
    }
    
    func testViewModelInitialization() {
        // Initialize the view model with mocks
        viewModel = CocktailMainViewModel(
            cocktailsAPI: mockAPI,
            favoritesRepository: mockFavoritesRepository
        )
        // Verify initial state
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.cocktailType, .all)
        XCTAssertEqual(viewModel.navigationTitle, "All Cocktails")
        XCTAssertTrue(viewModel.cocktails.isEmpty)
        XCTAssertTrue(viewModel.filteredCocktails.isEmpty)
        XCTAssertTrue(viewModel.favorites.count == mockFavoritesRepository.favorites.count)
    }
    
    func testFetchCocktailsSuccess() {
        let fetchExpectation = expectation(description: "Fetch cocktails")
        
        viewModel = CocktailMainViewModel(
            cocktailsAPI: FakeCocktailsAPI(),
            favoritesRepository: mockFavoritesRepository
        )
        viewModel.tryAgainFethcingCocktails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert that cocktails were fetched correctly
            XCTAssertEqual(self.viewModel.cocktails.count, 13)
            XCTAssertEqual(self.viewModel.filteredCocktails.count, 13)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.showErrorAlert)
            XCTAssertEqual(self.viewModel.errorMessage, "")
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 4.0)
    }
    
    func testFetchCocktailsFailure() {
        let fetchExpectation = expectation(description: "Fetch cocktails")
        
        viewModel = CocktailMainViewModel(
            cocktailsAPI: FakeCocktailsAPI(withFailure: .count(2)),
            favoritesRepository: mockFavoritesRepository
        )
        
        viewModel.tryAgainFethcingCocktails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert that cocktails were fetched correctly
            XCTAssertEqual(self.viewModel.cocktails.count, 0)
            XCTAssertEqual(self.viewModel.filteredCocktails.count, 0)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 4.0)
    }
    
    func testFiltering() {
        let fetchExpectation = expectation(description: "Fetch cocktails")
        
        viewModel.cocktailType = .nonAlcoholic
        viewModel.tryAgainFethcingCocktails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Verify that filteredCocktails only contains non-alcoholic cocktails
            XCTAssertEqual(self.viewModel.filteredCocktails.count, 4)
            XCTAssertEqual(self.viewModel.filteredCocktails.first?.type, "non-alcoholic")
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 4.0)
    }
    
    func testFavoriteToggle() {
        
        let fetchExpectation = expectation(description: "Fetch cocktails")
        
        viewModel = CocktailMainViewModel(
            cocktailsAPI: FakeCocktailsAPI(),
            favoritesRepository: mockFavoritesRepository
        )
        viewModel.tryAgainFethcingCocktails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert that cocktails were fetched correctly
            let favoriteCocktail = self.viewModel.cocktails[0]
            // Add a cocktail to favorites
            self.viewModel.onFavoriteToggle(favoriteCocktail)
            
            // Verify that the cocktail was added to favorites
            XCTAssertTrue(self.viewModel.favorites.contains(favoriteCocktail.id))
            
            // Remove the cocktail from favorites
            self.viewModel.onFavoriteToggle(favoriteCocktail)
            
            // Verify that the cocktail was removed from favorites
            XCTAssertFalse(self.viewModel.favorites.contains(favoriteCocktail.id))
            
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 4.0)
    }
    
}
