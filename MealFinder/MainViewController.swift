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
	
}

extension MainViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, !text.isEmpty else {
			return
		}
		
		searchBar.resignFirstResponder()
	}
}

	
