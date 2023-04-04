//
//  Models.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation


struct CategoryModel{
	let id: String
	let name: String
	let image: String
}


struct MealModel: Decodable {
	let name: String
	let image: String
}
