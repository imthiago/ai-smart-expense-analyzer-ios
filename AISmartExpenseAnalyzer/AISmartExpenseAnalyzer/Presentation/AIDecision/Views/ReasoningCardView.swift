//
//  ReasoningCardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class ReasoningCardView: CardView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PORQUE ESSA CATEGORIA?"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let reasoningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(spacing: 8)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(reasoningLabel)
    }

    required init?(coder: NSCoder) { nil }

    func configure(reasoning: String) {
        reasoningLabel.text = reasoning
    }
}
