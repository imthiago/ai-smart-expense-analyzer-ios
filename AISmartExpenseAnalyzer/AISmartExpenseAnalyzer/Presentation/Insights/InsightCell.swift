//
//  InsightCell.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class InsightCell: UITableViewCell {
    static let reuseIdentifier = "InsightCell"

    // MARK: - Components
    private let cardView: InsightCardView = {
        let view = InsightCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(with insight: Insight) {
        cardView.configure(with: insight)
    }
}
