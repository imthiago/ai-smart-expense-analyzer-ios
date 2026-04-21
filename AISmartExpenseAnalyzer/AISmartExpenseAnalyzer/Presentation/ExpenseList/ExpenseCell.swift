//
//  ExpenseCell.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class ExpenseCell: UITableViewCell {
    static let reuseIdentifier = "ExpenseCell"

    // MARK: - Components
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()

    private let aiBadge: UILabel = {
        let label = UILabel()
        label.text = "AI"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemIndigo
        label.backgroundColor = .systemIndigo.withAlphaComponent(0.12)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let pendingBadge: UILabel = {
        let label = UILabel()
        label.text = "⏳"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Configuration
    func configure(with expense: Expense) {
        descriptionLabel.text = expense.description
        amountLabel.text = expense.amount.formatted(.currency(code: "BRL"))
        dateLabel.text = expense.date.formatted(date: .abbreviated, time: .omitted)

        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        iconImageView.image = UIImage(systemName: expense.category.symbolName, withConfiguration: config)

        let color = expense.category.color
        iconContainer.backgroundColor = color.withAlphaComponent(0.15)
        iconImageView.tintColor = color
        amountLabel.textColor = color

        aiBadge.isHidden = !expense.wasAICategorized
        pendingBadge.isHidden = !expense.isCategorizationPending

        accessibilityLabel = "\(expense.description), \(expense.amount.formatted(.currency(code: "BRL")))"
        accessibilityIdentifier = "expense_cell_\(expense.id)"
    }

    // MARK: - Setup
    private func setupLayout() {
        let textStack = UIStackView(arrangedSubviews: [descriptionLabel, dateLabel])
        textStack.axis = .vertical
        textStack.spacing = 3

        let rightStack = UIStackView(arrangedSubviews: [amountLabel, aiBadge, pendingBadge])
        rightStack.axis = .vertical
        rightStack.alignment = .trailing
        rightStack.spacing = 4

        let mainStack = UIStackView(arrangedSubviews: [iconContainer, textStack, rightStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.addSubview(iconImageView)
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 44),
            iconContainer.heightAnchor.constraint(equalToConstant: 44),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}

