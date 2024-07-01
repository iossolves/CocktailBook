//
//  CocktailMainView.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import CocktailsAPI
import SwiftUI

struct CocktailMainView: View {
    
    @ObservedObject private var viewModel: CocktailMainViewModel = CocktailMainViewModel(cocktailsAPI: FakeCocktailsAPI(withFailure: .count(CocktailMainViewModel.callFailureCount)),
                                                                                         favoritesRepository: UserDefaultsRepository())
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.cocktailType) {
                    ForEach(CocktailMainViewModel.CocktailType.allCases, id: \.self) { type in
                        Text(type.getPickerTitle()).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.isLoading {
                    LoaderView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    CocktailListView(cocktails: viewModel.filteredCocktails,
                                     onFavoriteToggle: viewModel.onFavoriteToggle(_:))
                }
                
            }
            .navigationBarTitle(viewModel.navigationTitle)
            .alert(isPresented: $viewModel.showErrorAlert, content: errorAlert)
        }
    }
    
    private func errorAlert() -> Alert {
        Alert(
            title: Text("Error"),
            message: Text(viewModel.errorMessage),
            primaryButton: .default(Text("Try Again")) {
                viewModel.tryAgainFethcingCocktails()
            },
            secondaryButton: .cancel()
        )
    }
}
