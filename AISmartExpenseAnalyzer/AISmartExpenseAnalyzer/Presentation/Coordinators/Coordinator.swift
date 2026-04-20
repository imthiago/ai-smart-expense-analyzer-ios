//
//  Coordinator.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 20/04/26.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [any Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChild(_ coordinator: some Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: some Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
