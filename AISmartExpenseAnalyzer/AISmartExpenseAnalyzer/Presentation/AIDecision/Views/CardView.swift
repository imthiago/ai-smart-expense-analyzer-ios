//
//  CardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

class CardView: UIView {
    let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(spacing: CGFloat = 12) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        contentStack.spacing = spacing
        addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { nil }
}
