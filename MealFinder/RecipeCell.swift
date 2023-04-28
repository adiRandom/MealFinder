//
//  RecipeCell.swift
//  MealFinder
//
//  Created by Adrian Pascu on 04.04.2023.
//

import Foundation
import Kingfisher
import UIKit

class RecipeCell: UICollectionViewCell {
	static let CELL_IDENIFIER = "recipeCell"
	
	private let recipeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 8
		return imageView
	}()
		
	private let recipeNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		return label
	}()
		
	override init(frame: CGRect) {
		super.init(frame: frame)
			
		contentView.addSubview(recipeImageView)
		contentView.addSubview(recipeNameLabel)
			
		NSLayoutConstraint.activate([
			recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			recipeImageView.heightAnchor.constraint(equalToConstant: 64),
			
			recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 4),
			recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			recipeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
		
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	func configure(with meal: MealModel) {
		recipeNameLabel.text = meal.name
	
		if let imageUrl = URL(string: meal.image) {
			let resource = ImageResource(downloadURL: imageUrl, cacheKey: meal.image)
			recipeImageView.kf.setImage(with: resource)
		}
	}
}
