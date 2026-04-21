//
//  InsightCardView.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class InsightCardView: UIView {
    // MARK: - Components
    private let borderAccent: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Public
    func configure(with insight: Insight) {
        messageLabel.text = insight.message
        iconView.image = UIImage(systemName: insight.type.symbolName)
        iconView.tintColor = insight.type.color
        borderAccent.backgroundColor = insight.type.color
    }

    // MARK: - Setup
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true

        let contentStack = UIStackView(arrangedSubviews: [iconView, messageLabel])
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(borderAccent)
        addSubview(contentStack)

        NSLayoutConstraint.activate([
            borderAccent.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderAccent.topAnchor.constraint(equalTo: topAnchor),
            borderAccent.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderAccent.widthAnchor.constraint(equalToConstant: 4),

            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            contentStack.leadingAnchor.constraint(equalTo: borderAccent.trailingAnchor, constant: 14),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        ])
    }
}
