import Foundation

class MealRepository {
	private let baseURL = "https://www.themealdb.com/api/json/v1/1"
	
	func fetchRandomMeal(completion: @escaping (MealModel?) -> Void) {
		let urlString = "\(baseURL)/random.php"
		fetchData(urlString: urlString) { (result: Result<MealResponse, Error>) in
			let mealModelResult = result.map { $0.meals?.first?.toModel() }
			let mealModel = mealModelResult.resolve() ?? nil
			completion(mealModel)
		}
	}
	
	func fetchCategories(completion: @escaping ([CategoryModel]) -> Void) {
		let urlString = "\(baseURL)/categories.php"
		fetchData(urlString: urlString) { (result: Result<CategoriesResponse, Error>) in
			completion(result.map { $0.categories.map { category in category.toModel() }}.resolve() ?? [])
		}
	}
	
	func fetchMealsByCategory(_ category: String, completion: @escaping ([MealModel]) -> Void) {
		let urlString = "\(baseURL)/filter.php?c=\(category)"
		fetchData(urlString: urlString) { (result: Result<MealResponse, Error>) in
			completion(result.map { $0.meals?.map { meal in meal.toModel() } ?? [] }.resolve() ?? [])
		}
	}
	
	func searchMeal(_ searchText: String, completion: @escaping (MealModel?) -> Void) {
		let urlString = "\(baseURL)/search.php?s=\(searchText)"
		fetchData(urlString: urlString) { (result: Result<MealResponse, Error>) in
			let mealModelResult = result.map { $0.meals?.first?.toModel() }
			let mealModel = mealModelResult.resolve() ?? nil
			completion(mealModel)
		}
	}
	
	func fetchRecipe(id: String, completion: @escaping (RecipeModel?) -> Void){
		let urlString = "\(baseURL)/lookup.php?i=\(id)"
		fetchData(urlString: urlString) { (result: Result<RecipeResponse, Error>) in
			let recipeModelResponse = result.map { $0.meals.first?.toModel() }
			let recipeModel = recipeModelResponse.resolve() ?? nil
			completion(recipeModel)
		}
	}
	
	private func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
		guard let url = URL(string: urlString) else {
			completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
			return
		}
		
		URLSession.shared.dataTask(with: url) { data, _, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let data = data else {
				completion(.failure(NSError(domain: "Data is missing.", code: -1, userInfo: nil)))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let decodedData = try decoder.decode(T.self, from: data)
				completion(.success(decodedData))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}

// Helper extension
extension Result {
	func resolve() -> Success? {
		try? get()
	}
}
