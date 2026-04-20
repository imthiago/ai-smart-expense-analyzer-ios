//
//  SceneDelegate.swift
//  AISmartExpenseAnalyzer
//
//  Created by Thiago Oliveira on 18/04/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        do {
            let container = try AppContainer()
            let navigationController = UINavigationController()
            let coordinator = AppCoordinator(
                navigationController: navigationController,
                container: container
            )
            appCoordinator = coordinator
            window.rootViewController = navigationController
            coordinator.start()
        } catch {
            window.rootViewController = makeStoreErrorViewController(error: error)
        }

        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

    private func makeStoreErrorViewController(error: Error) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Failed to load local data.\n\(error.localizedDescription)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        viewController.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -32),
        ])

        return viewController
    }
}

