//
//  AppCoordinator.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []

    private let container: AppContainer

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let expenseList = ExpenseListCoordinator(
            navigationController: navigationController,
            container: container
        )
        addChild(expenseList)
        expenseList.start()
    }
}
