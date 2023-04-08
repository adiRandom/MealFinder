import CoreData
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
		let cachedCategories = fetchCachedCategories()
		if !cachedCategories.isEmpty {
			completion(cachedCategories)
			return
		}
		
		let urlString = "\(baseURL)/categories.php"
		fetchData(urlString: urlString) { [weak self] (result: Result<CategoriesResponse, Error>) in
			let categories = result.map {
				$0.categories.map {
					category in category.toModel()
				}
			}.resolve() ?? []
			
			completion(categories)
			categories.forEach { category in
				self?.saveCategory(category)
			}
		}
	}
	
	func fetchMealsByCategory(_ category: String, completion: @escaping ([MealModel]) -> Void) {
		let urlString = "\(baseURL)/filter.php?c=\(category)"
		fetchData(urlString: urlString) { (result: Result<MealResponse, Error>) in
			completion(result.map { $0.meals?.map { meal in meal.toModel() } ?? [] }.resolve() ?? [])
		}
	}
	
	func searchMeal(_ searchText: String, completion: @escaping (MealModel?) -> Void) {
		if let cachedMeal = fetchCachedMealByName(searchText) {
			completion(cachedMeal)
			return
		}
		
		let urlString = "\(baseURL)/search.php?s=\(searchText)"
		fetchData(urlString: urlString) { [weak self] (result: Result<MealResponse, Error>) in
			let mealModelResult = result.map { $0.meals?.first?.toModel() }
			let mealModel = mealModelResult.resolve() ?? nil
			completion(mealModel)
			
			if let mealModel {
				self?.saveMeal(mealModel)
			}
		}
	}
	
	func fetchRecipe(id: String, completion: @escaping (RecipeModel?) -> Void) {
		if let cachedRecipe = fetchCachedRecipe(by: id) {
			completion(cachedRecipe)
			return
		}
		
		let urlString = "\(baseURL)/lookup.php?i=\(id)"
		fetchData(urlString: urlString) { [weak self] (result: Result<RecipeResponse, Error>) in
			let recipeModelResponse = result.map { $0.meals.first?.toModel() }
			let recipeModel = recipeModelResponse.resolve() ?? nil
			completion(recipeModel)
			
			if let recipeModel {
				self?.saveRecipe(recipeModel)
			}
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
	
	private func saveCategory(_ category: CategoryModel) {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let cachedCategory = CachedCategory(context: context)
		cachedCategory.id = category.id
		cachedCategory.name = category.name
		cachedCategory.imageUrl = category.image
		
		CoreDataStack.shared.saveContext()
	}
	
	private func saveRecipe(_ recipe: RecipeModel) {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let cachedRecipe = CachedRecipe(context: context)
		cachedRecipe.id = recipe.id
		cachedRecipe.name = recipe.name
		cachedRecipe.imageUrl = recipe.image
		cachedRecipe.instructions = recipe.instructions
		do {
			cachedRecipe.ingredients = try NSKeyedArchiver.archivedData(withRootObject: recipe.ingredients, requiringSecureCoding: false)
		} catch {
			print("Error saving ingredients: \(error)")
			return
		}
		
		CoreDataStack.shared.saveContext()
	}

	// Save meal
	private func saveMeal(_ meal: MealModel) {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let cachedMeal = CachedMeal(context: context)
		cachedMeal.id = meal.id
		cachedMeal.name = meal.name
		cachedMeal.imageUrl = meal.image
		
		CoreDataStack.shared.saveContext()
	}
	
	// Fetch categories
	private func fetchCachedCategories() -> [CategoryModel] {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<CachedCategory> = CachedCategory.fetchRequest()
		
		do {
			let cachedCategories = try context.fetch(fetchRequest)
			return cachedCategories.map { CategoryModel(id: $0.id!, name: $0.name!, image: $0.imageUrl!) }
		} catch {
			print("Error fetching categories from CoreData: \(error)")
			return []
		}
	}

	// Fetch meal by id
	private func fetchCachedMealByName(_ name: String) -> MealModel? {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<CachedMeal> = CachedMeal.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name == %@", name)
		
		do {
			let cachedMeals = try context.fetch(fetchRequest)
			guard let cachedMeal = cachedMeals.first else { return nil }
			return MealModel(name: cachedMeal.name!, image: cachedMeal.imageUrl!, id: cachedMeal.id!)
		} catch {
			print("Error fetching meal from CoreData: \(error)")
			return nil
		}
	}
	
	private func fetchCachedRecipe(by id: String) -> RecipeModel? {
		let context = CoreDataStack.shared.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<CachedRecipe> = CachedRecipe.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %@", id)
		
		do {
			let cachedRecipes = try context.fetch(fetchRequest)
			guard let cachedRecipe = cachedRecipes.first else { return nil }
			return try RecipeModel(
				id: cachedRecipe.id!,
				name: cachedRecipe.name!,
				image: cachedRecipe.imageUrl!,
				instructions: cachedRecipe.instructions!,
				ingredients: NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: cachedRecipe.ingredients!) as? [Ingredient] ?? []
			)
			
		} catch {
			print("Error fetching meal from CoreData: \(error)")
			return nil
		}
	}
}

// Helper extension
extension Result {
	func resolve() -> Success? {
		try? get()
	}
}
