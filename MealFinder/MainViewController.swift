//
//  ViewController.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Kingfisher
import UIKit

class MainViewController: UIViewController {
	private let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		return searchBar
	}()
		
	private let headerLabel: UILabel = {
		let label = UILabel()
		label.text = "Feeling Lucky"
		label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
		
	private let randomMealImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 12
		imageView.isUserInteractionEnabled = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
		
	private let mealNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .clear
		return collectionView
	}()
	
	private var categories: [CategoryModel] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		fetchRandomMeal()
	}
		
	private func setupViews() {
		view.addSubview(searchBar)
		view.addSubview(headerLabel)
		view.addSubview(randomMealImageView)
		view.addSubview(mealNameLabel)
			
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(randomMealTapped))
		randomMealImageView.addGestureRecognizer(tapGestureRecognizer)
		searchBar.delegate = self
		
		// Load the categories
		view.addSubview(categoriesCollectionView)
		categoriesCollectionView.dataSource = self
		categoriesCollectionView.delegate = self
		categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.CELL_IDENTIFIER)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				
			headerLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
			headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				
			randomMealImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
			randomMealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
			randomMealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
			randomMealImageView.heightAnchor.constraint(equalToConstant: 200),
															   
			mealNameLabel.topAnchor.constraint(equalTo: randomMealImageView.bottomAnchor, constant: 5),
			mealNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			categoriesCollectionView.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 10),
			categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			categoriesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
													   
	@objc private func randomMealTapped() {
		// Handle meal image tap event
	}
	
	private func loadImage(from url: URL) {
		randomMealImageView.kf.setImage(with: url)
	}
	
	private func updateUI(with meal: MealDto) {
		mealNameLabel.text = meal.strMeal
		
		if let imageUrl = URL(string: meal.strMealThumb) {
			loadImage(from: imageUrl)
		}
	}

	private func fetchRandomMeal() {
		let urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
		
		guard let url = URL(string: urlString) else {
			print("Invalid URL")
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let data = data, error == nil else {
				print("Error fetching data")
				return
			}
			
			do {
				let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
				DispatchQueue.main.async {
					self?.updateUI(with: mealResponse.meals[0])
				}
			} catch {
				print("Error decoding JSON: \(error)")
			}
		}
		
		task.resume()
	}
	
	private func fetchCategories() {
		let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
		
		guard let url = URL(string: urlString) else {
			print("Invalid URL")
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
			guard let data = data, error == nil else {
				print("Error fetching data")
				return
			}
			
			do {
				let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
				DispatchQueue.main.async {
					self?.categories = categoriesResponse.categories.map { dto in dto.toModel() }
					self?.categoriesCollectionView.reloadData()
				}
			} catch {
				print("Error decoding JSON: \(error)")
			}
		}
		
		task.resume()
	}
}

extension MainViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, !text.isEmpty else {
			return
		}
		
		searchBar.resignFirstResponder()
	}
}

extension MainViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.CELL_IDENTIFIER, for: indexPath) as? CategoryCell ?? CategoryCell()

		let category = categories[indexPath.item]
		cell.configure(with: category)
		return cell
	}
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let PADDING_SPACE:Double = 8 * (3 + 1) // 3 columns with 8 points of padding in between and on the sides
		let ITEM_HEIGHT:Double = 64
		
		let availableWidth = collectionView.bounds.width - CGFloat(PADDING_SPACE)
		let widthPerItem = availableWidth / 3
	
		return CGSize(width: widthPerItem, height: ITEM_HEIGHT)
	}
}
