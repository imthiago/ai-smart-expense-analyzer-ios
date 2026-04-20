//
//  AddExpenseCoordinator.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class AddExpenseCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    private let container: AppContainer

    var onExpenseAdded: ((Expense) -> Void)?
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewModel = AddExpenseViewModel(addExpenseUseCase: container.addExpenseUseCase)

        viewModel.onDismiss = { [weak self] in
            self?.navigationController.dismiss(animated: true)
            self?.onFinish?()
        }

        viewModel.onExpenseAdded = { [weak self] expense in
            self?.navigationController.dismiss(animated: true)
            self?.onExpenseAdded?(expense)
            self?.onFinish?()
        }

        let viewController = AddExpenseViewController(viewModel: viewModel)
        let sheet = UINavigationController(rootViewController: viewController)
        sheet.modalPresentationStyle = .pageSheet

        if let detents = sheet.sheetPresentationController {
            detents.detents = [.medium(), .large()]
            detents.prefersGrabberVisible = true
        }

        navigationController.present(sheet, animated: true)
    }
}
