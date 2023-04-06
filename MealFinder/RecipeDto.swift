//
//  RecipeModel.swift
//  MealFinder
//
//  Created by Adrian Pascu on 05.04.2023.
//

import Foundation

struct RecipeResponse: Codable {
	let meals: [RecipeDto]
}

struct RecipeDto: Codable {
	let id: String
	let name: String
	let image: String
	let instructions: String
	
	let strIngredient1: String?
	let strIngredient2: String?
	let strIngredient3: String?
	let strIngredient4: String?
	let strIngredient5: String?
	let strIngredient6: String?
	let strIngredient7: String?
	let strIngredient8: String?
	let strIngredient9: String?
	let strIngredient10: String?
	let strIngredient11: String?
	let strIngredient12: String?
	let strIngredient13: String?
	let strIngredient14: String?
	let strIngredient15: String?
	let strIngredient16: String?
	let strIngredient17: String?
	let strIngredient18: String?
	let strIngredient19: String?
	let strIngredient20: String?
	
	
	let strMeasure1: String?
	let strMeasure2: String?
	let strMeasure3: String?
	let strMeasure4: String?
	let strMeasure5: String?
	let strMeasure6: String?
	let strMeasure7: String?
	let strMeasure8: String?
	let strMeasure9: String?
	let strMeasure10: String?
	let strMeasure11: String?
	let strMeasure12: String?
	let strMeasure13: String?
	let strMeasure14: String?
	let strMeasure15: String?
	let strMeasure16: String?
	let strMeasure17: String?
	let strMeasure18: String?
	let strMeasure19: String?
	let strMeasure20: String?
	
	
	func getIngredients() -> [Ingredient] {
		var ingredients = [Ingredient]()
	
		if let ingredient1 = strIngredient1, let measure1 = strMeasure1 {
			ingredients.append(Ingredient(name: ingredient1, measure: measure1))
		}
		if let ingredient2 = strIngredient2, let measure2 = strMeasure2 {
			ingredients.append(Ingredient(name: ingredient2, measure: measure2))
		}
		if let ingredient3 = strIngredient3, let measure3 = strMeasure3 {
			ingredients.append(Ingredient(name: ingredient3, measure: measure3))
		}
		if let ingredient4 = strIngredient4, let measure4 = strMeasure4 {
			ingredients.append(Ingredient(name: ingredient4, measure: measure4))
		}
		if let ingredient5 = strIngredient5, let measure5 = strMeasure5 {
			ingredients.append(Ingredient(name: ingredient5, measure: measure5))
		}
		if let ingredient6 = strIngredient6, let measure6 = strMeasure6 {
			ingredients.append(Ingredient(name: ingredient6, measure: measure6))
		}
		if let ingredient7 = strIngredient7, let measure7 = strMeasure7 {
			ingredients.append(Ingredient(name: ingredient7, measure: measure7))
		}
		if let ingredient8 = strIngredient8, let measure8 = strMeasure8 {
			ingredients.append(Ingredient(name: ingredient8, measure: measure8))
		}
		if let ingredient9 = strIngredient9, let measure9 = strMeasure9 {
			ingredients.append(Ingredient(name: ingredient9, measure: measure9))
		}
		if let ingredient10 = strIngredient10, let measure10 = strMeasure10 {
			ingredients.append(Ingredient(name: ingredient10, measure: measure10))
		}
		if let ingredient11 = strIngredient11, let measure11 = strMeasure11 {
			ingredients.append(Ingredient(name: ingredient11, measure: measure11))
		}
		if let ingredient12 = strIngredient12, let measure12 = strMeasure12 {
			ingredients.append(Ingredient(name: ingredient12, measure: measure12))
		}
		if let ingredient13 = strIngredient13, let measure13 = strMeasure13 {
			ingredients.append(Ingredient(name: ingredient13, measure: measure13))
		}
		if let ingredient14 = strIngredient14, let measure14 = strMeasure14 {
			ingredients.append(Ingredient(name: ingredient14, measure: measure14))
		}
		if let ingredient15 = strIngredient15, let measure15 = strMeasure15 {
			ingredients.append(Ingredient(name: ingredient15, measure: measure15))
		}
		if let ingredient16 = strIngredient16, let measure16 = strMeasure16 {
			ingredients.append(Ingredient(name: ingredient16, measure: measure16))
		}
		if let ingredient17 = strIngredient17, let measure17 = strMeasure17 {
			ingredients.append(Ingredient(name: ingredient17, measure: measure17))
		}
		if let ingredient18 = strIngredient18, let measure18 = strMeasure18 {
			ingredients.append(Ingredient(name: ingredient18, measure: measure18))
		}
		if let ingredient19 = strIngredient19, let measure19 = strMeasure19 {
			ingredients.append(Ingredient(name: ingredient19, measure: measure19))
		}
		if let ingredient20 = strIngredient20, let measure20 = strMeasure20 {
			ingredients.append(Ingredient(name: ingredient20, measure: measure20))
		}
		
		return ingredients
	}
	
	func toModel()->RecipeModel {
		return RecipeModel(id: id, name: name, image: image, instructions: instructions, ingredients: getIngredients())
	}
}

extension RecipeDto {
	private enum CodingKeys: String, CodingKey {
		case id = "idMeal"
		case name = "strMeal"
		case image = "strMealThumb"
		case instructions = "strInstructions"
		

		case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
		     strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
		     strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
		     strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20

		case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
		     strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
		     strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
		     strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
	}
}
