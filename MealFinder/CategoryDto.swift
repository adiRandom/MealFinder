//
//  CategoryDto.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation

struct CategoriesResponse: Codable {
	let categories: [CategoryDto]
}

struct CategoryDto: Codable {
	let idCategory: String
	let strCategory: String
	let strCategoryThumb: String
	
	func toModel() -> CategoryModel {
		return CategoryModel(id: idCategory, name: strCategory, image: strCategoryThumb)
	}
}
