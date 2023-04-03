//
//  MealDto.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation

struct MealResponse: Decodable {
	let meals: [MealDto]
}

struct MealDto: Decodable {
	let strMeal: String
	let strMealThumb: String
}
