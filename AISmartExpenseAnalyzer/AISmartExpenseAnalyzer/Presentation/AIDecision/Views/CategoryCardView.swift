//
//  CategoryCardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class CategoryCardView: CardView {
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 64),
            view.heightAnchor.constraint(equalToConstant: 64)
        ])
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let confidenceBadge: ConfidenceBadgeView = {
        let view = ConfidenceBadgeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(spacing: 10)

        contentStack.alignment = .center
        contentStack.axis = .horizontal

        iconContainerView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor)
        ])

        contentStack.addArrangedSubview(iconContainerView)
        contentStack.addArrangedSubview(categoryLabel)
        contentStack.addArrangedSubview(confidenceBadge)
    }

    required init?(coder: NSCoder) { nil }

    func configure(category: Category, displayName: String, symbolName: String, confidence: Double) {
        iconContainerView.backgroundColor = category.color.withAlphaComponent(0.15)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        iconImageView.image = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        iconImageView.tintColor = category.color
        categoryLabel.text = displayName
        confidenceBadge.confidence = confidence
    }
}
