//
//  CocktailListView.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import SwiftUI

class Test: ObservableObject {
    
}

struct CocktailListView: View {
        
    let cocktails: [Cocktail]
    let onFavoriteToggle: (Cocktail) -> Void

    var body: some View {
        List(cocktails) { cocktail in
            NavigationLink(destination: CocktailDetailView(cocktail: cocktail, onFavoriteToggle: onFavoriteToggle)) {
                cocktailRowView(for: cocktail)
            }
        }
    }

    private func cocktailRowView(for cocktail: Cocktail) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cocktail.name)
                    .font(.headline)
                    .foregroundColor(cocktail.isFavorite ? .orange : .primary)
                Text(cocktail.shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if cocktail.isFavorite {
                Image(systemName: "heart.fill")
                    .frame(width: 24, height: 24)
                    .foregroundColor(.orange)
            }
        }
    }
}
