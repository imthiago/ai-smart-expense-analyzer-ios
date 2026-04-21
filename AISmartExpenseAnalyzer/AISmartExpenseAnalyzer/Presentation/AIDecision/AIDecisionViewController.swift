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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AI Decision"
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
        
    }
}

// MARK: - Factory subview methods
extension AIDecisionViewController {
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
