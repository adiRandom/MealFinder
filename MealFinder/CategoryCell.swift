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
	private let categoryButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 8
		button.clipsToBounds = true
		return button
	}()
	   
	override init(frame: CGRect) {
		super.init(frame: frame)
		   
		contentView.addSubview(categoryButton)
		   
		NSLayoutConstraint.activate([
			categoryButton.topAnchor.constraint(equalTo: contentView.topAnchor),
			categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			categoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	   
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
		
	func configure(with category: CategoryModel) {
		categoryButton.setTitle(category.name.uppercased(), for: .normal)
			
		if let imageUrl = URL(string: category.image) {
			let processor = BlurImageProcessor(blurRadius: 10)
			let resource = ImageResource(downloadURL: imageUrl, cacheKey: category.image)
			categoryButton.kf.setBackgroundImage(with: resource, for: .normal, options: [.processor(processor)])
		}
	}
}
