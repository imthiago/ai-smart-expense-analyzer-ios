//
//  ExpenseListCoordinator.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class ExpenseListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let container: AppContainer

    private weak var listViewModel: ExpenseListViewModel?

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewModel = ExpenseListViewModel(
            getExpensesUseCase: container.getExpensesUseCase,
            deleteExpenseUseCase: container.deleteExpenseUseCase,
            generateInsightsUseCase: container.generateInsightsUseCase
        )

        listViewModel = viewModel

        viewModel.onAddExpense = { [weak self] in
            self?.showAddExpense()
        }

        viewModel.onSelectExpense = { [weak self] expense in
            self?.showAIDecision(for: expense)
        }

        if container.featureFlags.insightsEnabled {
            viewModel.onShowInsights = { [weak self] expenses in
                self?.showInsights(for: expenses)
            }
        }

        let viewController = ExpenseListViewController(
            viewModel: viewModel,
            insightsEnabled: container.featureFlags.insightsEnabled
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    // MARK: - Navigation
    private func showAddExpense() {
        // TODO: To be implemented
    }

    private func showAIDecision(for expense: Expense) {
        // TODO: To be implemented
    }

    private func showInsights(for expenses: [Expense]) {
        // TODO: To be implemented
    }
}
