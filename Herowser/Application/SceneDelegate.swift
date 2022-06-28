//
//  SceneDelegate.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        launch(scene: scene)
    }

    static var current: SceneDelegate? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            return sceneDelegate
        }
        return nil
    }

    func presentedController() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            var controller = sceneDelegate.window?.rootViewController
            if let presented = controller?.presentedViewController {
                controller = presented
            }
            return controller
        }
        return nil
    }

}

private extension SceneDelegate {

    // MARK: - Private Helpers

    func createMainCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
        let router = Router(with: navigationController)
        mainCoordinator = MainCoordinator(with: router)
        mainCoordinator?.start()
        return navigationController
    }

    func launch(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = createMainCoordinator()
        window?.makeKeyAndVisible()
    }

}

