//
//  MealDto.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation

struct MealResponse: Decodable {
	let meals: [MealDto]?
}

struct MealDto: Decodable {
	let idMeal: String
	let strMeal: String
	let strMealThumb: String
	
	func toModel(category:String)->MealModel{
		return MealModel(name: strMeal, image: strMealThumb, id: idMeal, categoryName: category)
	}
}
