//
//  CocktailDetailView.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import SwiftUI

struct CocktailDetailView: View {
    @ObservedObject private var viewModel: CocktailDetailViewModel
    
    init(cocktail: Cocktail, onFavoriteToggle: @escaping (Cocktail) -> Void) {
        viewModel = CocktailDetailViewModel(cocktail: cocktail, onFavoriteToggle: onFavoriteToggle)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 20))
                        .padding(.trailing, 5)
                    Text("\(viewModel.cocktail.preparationMinutes) minutes")
                }
                .padding()
                
                Image(viewModel.cocktail.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
                    .padding()
                
                Text(viewModel.cocktail.longDescription)
                    .padding()
                
                Text("Ingredients:")
                    .font(.headline)
                    .padding([.top, .leading])
                
                ForEach(viewModel.cocktail.ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12))
                        Text(ingredient)
                    }
                    .padding(.leading)
                }
            }
            .padding()
            .navigationBarTitle(viewModel.cocktail.name)
            .navigationBarItems(trailing: Button(action: {
                viewModel.toggleFavorite()
            }) {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(viewModel.isFavorite ? .orange : .gray)
            })
        }
    }
}
