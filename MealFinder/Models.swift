//
//  Models.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation

struct CategoryModel {
	let id: String
	let name: String
	let image: String
}

struct MealModel: Decodable {
	let name: String
	let image: String
	let id: String
	let categoryName: String
}

struct Ingredient: Codable {
	let name: String
	let measure: String
}

struct RecipeModel{
	let id: String
	let name: String
	let image: String
	let categoryName: String
	let instructions: String
	let ingredients: [Ingredient]
	
	func toMealModel() -> MealModel{
		return MealModel(name: name, image: image, id: id, categoryName: categoryName)
	}
}
