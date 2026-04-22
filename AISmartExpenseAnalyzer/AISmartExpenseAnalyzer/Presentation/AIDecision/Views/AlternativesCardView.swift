//
//  AlternativesCardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class AlternativesCardView: CardView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ALTERNATIVAS CONSIDERADAS"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    init() {
        super.init(spacing: 10)
        contentStack.addArrangedSubview(titleLabel)
    }

    required init?(coder: NSCoder) { nil }

    func configure(alternatives: [CategoryConfidence]) {
        contentStack.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }

        for alt in alternatives {
            let badge = ConfidenceBadgeView()
            badge.confidence = alt.confidence

            let nameLabel = UILabel()
            nameLabel.text = alt.category.displayName
            nameLabel.font = .systemFont(ofSize: 15)

            let row = UIStackView(arrangedSubviews: [nameLabel, UIView(), badge])
            row.axis = .horizontal
            row.alignment = .center
            contentStack.addArrangedSubview(row)
        }
    }
}
