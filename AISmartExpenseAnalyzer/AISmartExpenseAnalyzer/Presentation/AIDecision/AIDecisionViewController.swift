//
//  AIDecisionViewController.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 21/04/26.
//

import UIKit

final class AIDecisionViewController: UIViewController {
    // MARK: - ViewModel
    private let viewModel: AIDecisionViewModel

    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init(viewModel: AIDecisionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AI Decision"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        populate()
    }

    // MARK: - Layout
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func populate() {
        contentStack.addArrangedSubview(makeExpenseHeader())
        contentStack.addArrangedSubview(makeCategoryCard())

        if viewModel.hasAIDecision {
            contentStack.addArrangedSubview(makeReasoningCard())
            if !viewModel.alternativeCategories.isEmpty {
                contentStack.addArrangedSubview(makeAlternativesCard())
            }
            contentStack.addArrangedSubview(makeMetadataCard())
        }
    }
}

// MARK: - Factory subview methods
extension AIDecisionViewController {
    private func makeExpenseHeader() -> UIView {
        let amountLabel = UILabel()
        amountLabel.text = viewModel.expenseAmount
        amountLabel.font = .systemFont(ofSize: 34, weight: .bold)
        amountLabel.textAlignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.text = viewModel.expenseDescription
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2

        return makeCard(arrangedSubViews: [amountLabel, descriptionLabel], spacing: 6)
    }

    private func makeCategoryCard() -> UIView {
        let iconView = UIView()
        iconView.layer.cornerRadius = 32
        iconView.layer.masksToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let category = viewModel.expense.category
        iconView.backgroundColor = category.color.withAlphaComponent(0.15)

        let iconImageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        iconImageView.image = UIImage(systemName: viewModel.categorySymbolName, withConfiguration: config)
        iconImageView.tintColor = category.color
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])

        let categoryLabel = UILabel()
        categoryLabel.text = viewModel.categoryDisplayName
        categoryLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        categoryLabel.textAlignment = .center

        let confidenceBadge = ConfidenceBadgeView()
        confidenceBadge.confidence = viewModel.confidence
        confidenceBadge.translatesAutoresizingMaskIntoConstraints = false

        let iconStack = UIStackView(arrangedSubviews: [iconView])
        iconStack.axis = .horizontal
        iconStack.alignment = .center
        iconStack.distribution = .equalCentering

        let badgeStack = UIStackView(arrangedSubviews: [confidenceBadge])
        badgeStack.axis = .horizontal
        badgeStack.alignment = .center

        return makeCard(arrangedSubViews: [iconStack, categoryLabel, badgeStack], spacing: 10)
    }

    private func makeReasoningCard() -> UIView {
        let titleLabel = makeSectionTitle("Porque essa categoria?")

        let reasoningLabel = UILabel()
        reasoningLabel.text = viewModel.reasoning
        reasoningLabel.font = .systemFont(ofSize: 15)
        reasoningLabel.textColor = .label
        reasoningLabel.numberOfLines = 0

        return makeCard(arrangedSubViews: [titleLabel, reasoningLabel], spacing: 8)
    }
    private func makeAlternativesCard() -> UIView {
        let titleLabel = makeSectionTitle("Alternativas consideradas")
        let rows = viewModel.alternativeCategories.map { alt -> UIView in
            let badge = ConfidenceBadgeView()
            badge.confidence = alt.confidence
            badge.translatesAutoresizingMaskIntoConstraints = false

            let nameLabel = UILabel()
            nameLabel.text = alt.category.displayName
            nameLabel.font = .systemFont(ofSize: 15)

            let row = UIStackView(arrangedSubviews: [nameLabel, UIView(), badge])
            row.axis = .horizontal
            row.alignment = .center
            return row
        }
        return makeCard(arrangedSubViews: [titleLabel] + rows, spacing: 10)
    }

    private func makeMetadataCard() -> UIView {
        let providerRow = makeMetadataRow(
            icon: "cpu",
            label: "Provider",
            value: viewModel.providerName
        )

        let dateRow = makeMetadataRow(
            icon: "clock",
            label: "Processed",
            value: viewModel.processedAt
        )

        return makeCard(arrangedSubViews: [providerRow, dateRow], spacing: 12)
    }

    private func makeCard(arrangedSubViews: [UIView], spacing: CGFloat) -> UIView {
        let stack = UIStackView(arrangedSubviews: arrangedSubViews)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        return container
    }

    private func makeSectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.textTransform(uppercase: true)
        return label
    }

    private func makeMetadataRow(icon: String, label: String, value: String) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true

        let labelView = UILabel()
        labelView.text = label
        labelView.font = .systemFont(ofSize: 14)
        labelView.textColor = .secondaryLabel

        let valueView = UILabel()
        labelView.text = value
        labelView.font = .systemFont(ofSize: 14, weight: .medium)
        valueView.textAlignment = .right

        let row = UIStackView(arrangedSubviews: [iconView, labelView, UIView(), valueView])
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        return row
    }
}

// MARK: - UILabel+Extension
private extension UILabel {
    func textTransform(uppercase: Bool) {
        if uppercase, let text {
            self.text = text.uppercased()
        }
    }
}
