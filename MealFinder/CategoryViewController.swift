import Kingfisher
import UIKit

class CategoryViewController: UIViewController {
	var category: CategoryModel!

	private let categoryImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let categoryNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
		return label
	}()
	
	private let recipesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .clear
		return collectionView
	}()
	
	private var recipes: [MealModel] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = ""
		setupViews()
		setupConstraints()
		fetchRecipes()
	}

	private func setupViews() {
		view.addSubview(categoryImageView)
		categoryImageView.kf.setImage(with: URL(string: category.image))
		view.addSubview(categoryNameLabel)
		categoryNameLabel.text = category.name.uppercased()
		
		view.addSubview(recipesCollectionView)
		recipesCollectionView.dataSource = self
		recipesCollectionView.delegate = self
		recipesCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.CELL_IDENIFIER)
	}
		  
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			categoryImageView.topAnchor.constraint(equalTo: view.topAnchor),
			categoryImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			categoryImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			categoryImageView.heightAnchor.constraint(equalToConstant: 200),
				  
			categoryNameLabel.centerXAnchor.constraint(equalTo: categoryImageView.centerXAnchor),
			categoryNameLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
				  
			recipesCollectionView.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor),
			recipesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			recipesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			recipesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
			  
		categoryImageView.layer.cornerRadius = 16
		categoryImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
	}
		  
	private func fetchRecipes() {
		let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category.name)"
		guard let url = URL(string: urlString) else { return }

		URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let data = data, error == nil else { return }
			
			do {
				let mealsResponse = try JSONDecoder().decode(MealResponse.self, from: data)
				DispatchQueue.main.async {
					self?.recipes = mealsResponse.meals.map{dto in dto.toModel()}
					self?.recipesCollectionView.reloadData()
				}
			} catch {
				print("Error decoding recipes: \(error)")
			}
		}.resume()
	}
}

extension CategoryViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recipes.count
	}
		  
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.CELL_IDENIFIER, for: indexPath) as? RecipeCell ?? RecipeCell()
		let recipe = recipes[indexPath.item]
		cell.configure(with: recipe)
		return cell
	}
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let PADDING_SPACE: Double = 8 * (3 + 1) // 3 columns with 8 points of padding in between and on the sides
		let ITEM_HEIGHT: Double = 80
		
		let availableWidth = collectionView.bounds.width - CGFloat(PADDING_SPACE)
		let widthPerItem = availableWidth / 3
	
		return CGSize(width: widthPerItem, height: ITEM_HEIGHT)
	}
}
