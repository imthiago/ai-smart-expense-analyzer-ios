//
//  ExpenseHeaderView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class ExpenseHeaderView: CardView {
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    init() {
        super.init(spacing: 6)
        contentStack.addArrangedSubview(amountLabel)
        contentStack.addArrangedSubview(descriptionLabel)
    }

    required init?(coder: NSCoder) { nil }

    func configure(amount: String, description: String) {
        amountLabel.text = amount
        descriptionLabel.text = description
    }
}
