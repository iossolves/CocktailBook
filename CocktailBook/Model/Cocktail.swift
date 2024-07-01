//
//  Cocktail.swift
//  CocktailBook
//
//  Created by Karunakar on 17/06/24.
//

import Foundation

struct Cocktail: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, shortDescription, longDescription, preparationMinutes, imageName, ingredients, isFavorite
    }
    
    init(id: String, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = type
        self.shortDescription = ""
        self.longDescription = ""
        self.preparationMinutes = 4
        self.imageName = ""
        self.ingredients = []
        self.isFavorite = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.longDescription = try container.decode(String.self, forKey: .longDescription)
        self.preparationMinutes = try container.decode(Int.self, forKey: .preparationMinutes)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.ingredients = try container.decode([String].self, forKey: .ingredients)
        self.isFavorite = false // Default value, modify if needed
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(shortDescription, forKey: .shortDescription)
        try container.encode(longDescription, forKey: .longDescription)
        try container.encode(preparationMinutes, forKey: .preparationMinutes)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}
