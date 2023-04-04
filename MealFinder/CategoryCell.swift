//
//  CategoryCell.swift
//  MealFinder
//
//  Created by Adrian Pascu on 03.04.2023.
//

import Foundation
import Kingfisher
import UIKit

class CategoryCell: UICollectionViewCell {
	static let CELL_IDENTIFIER = "CategoryCell"
	private let categoryImage: UIImageView = {
		let button = UIImageView()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 8
		button.clipsToBounds = true
		return button
	}()
	
	private let categoryLabel: UILabel = {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.textAlignment = .center
			label.textColor = .black
			label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
			return label
		}()
	   
	override init(frame: CGRect) {
		super.init(frame: frame)
		   
		contentView.addSubview(categoryImage)
		contentView.addSubview(categoryLabel)
		   
		NSLayoutConstraint.activate([
			categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			categoryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			categoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			categoryImage.heightAnchor.constraint(equalToConstant: 64),
			
			categoryLabel.topAnchor.constraint(equalTo: categoryImage.bottomAnchor, constant: 4),
			categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	   
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	func configure(with category: CategoryModel) {
		categoryLabel.text = category.name.uppercased()

		if let imageUrl = URL(string: category.image) {
			let resource = ImageResource(downloadURL: imageUrl, cacheKey: category.image)
			categoryImage.kf.setImage(with: resource)
		}
	}
}
