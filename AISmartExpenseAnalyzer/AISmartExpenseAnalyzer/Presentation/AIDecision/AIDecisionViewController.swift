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

    // MARK: - Layout
    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Components
    private let expenseHeaderView = ExpenseHeaderView()
    private let categoryCardView = CategoryCardView()
    private let reasoningCardView = ReasoningCardView()
    private let alternativesCardView = AlternativesCardView()
    private let metadataCardView = MetadataCardView()

    // MARK: - Init
    init(viewModel: AIDecisionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        configure()
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

    // MARK: - Configuration
    private func configure() {
        expenseHeaderView.configure(
            amount: viewModel.expenseAmount,
            description: viewModel.expenseDescription
        )

        contentStack.addArrangedSubview(expenseHeaderView)

        categoryCardView.configure(
            category: viewModel.expense.category,
            displayName: viewModel.categoryDisplayName,
            symbolName: viewModel.categorySymbolName,
            confidence: viewModel.confidence
        )

        contentStack.addArrangedSubview(categoryCardView)

        guard viewModel.hasAIDecision else { return }

        reasoningCardView.configure(reasoning: viewModel.reasoning)
        contentStack.addArrangedSubview(reasoningCardView)

        if !viewModel.alternativeCategories.isEmpty {
            alternativesCardView.configure(alternatives: viewModel.alternativeCategories)
            contentStack.addArrangedSubview(alternativesCardView)
        }

        metadataCardView.configure(
            provider: viewModel.providerName,
            processedAt: viewModel.processedAt
        )

        contentStack.addArrangedSubview(metadataCardView)
    }
}
