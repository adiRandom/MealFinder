import Kingfisher
import UIKit

class RecipeViewController: UIViewController {
	var mealId: String?
	var recipe: RecipeModel?
	
	private let mealImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		imageView.layer.cornerRadius = 16
		return imageView
	}()

	private let mealNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
		label.textColor = .black
		return label
	}()

	private let ingredientsLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
		label.textColor = .black
		label.numberOfLines = 0
		return label
	}()
	
	private let instructionsLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .left
		label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
		label.textColor = .black
		label.numberOfLines = 0
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		   
		view.backgroundColor = .white
		   
		view.addSubview(mealImageView)
		view.addSubview(mealNameLabel)
		view.addSubview(ingredientsLabel)
		view.addSubview(instructionsLabel)

		setupConstraints()
		fetchRecipe()
	}
	
	private func fetchRecipe() {
		guard let mealId = mealId, let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else { return }
		
		URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let data = data, error == nil else { return }
			
			do {
				let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
				DispatchQueue.main.async {
					self?.recipe = recipeResponse.meals.first?.toModel()
					self?.setupUI()
				}
			} catch {
				print("Error decoding recipe: \(error)")
			}
		}.resume()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			mealImageView.topAnchor.constraint(equalTo: view.topAnchor),
			mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mealImageView.heightAnchor.constraint(equalTo: view.widthAnchor),
			
			mealNameLabel.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 8),
			mealNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			mealNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			ingredientsLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 8),
			ingredientsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			ingredientsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			ingredientsLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			
			instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 16),
			instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			instructionsLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
		])
	}
	
	private func setupUI() {
		guard let recipe = recipe else { return }
		
		instructionsLabel.text = recipe.instructions
	
		mealNameLabel.text = recipe.name
		
		if let imageUrl = URL(string: recipe.image) {
			let resource = ImageResource(downloadURL: imageUrl, cacheKey: recipe.image)
			mealImageView.kf.setImage(with: resource)
		}
		
		let ingredientsText = recipe.ingredients.map { "\($0.name) ..... \($0.measure)" }.joined(separator: "\n")
		ingredientsLabel.text = ingredientsText
	}
}
