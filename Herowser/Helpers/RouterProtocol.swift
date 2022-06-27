//
//  RouterProtocol.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

public protocol RouterProtocol: AnyObject {

    var navigationController: UINavigationController { get }

    var navigationBarHidden: Bool { get }

    func push(_ drawable: Drawable, onNavigateBack: NavigationBackHandler?)
    func push(_ drawable: Drawable, animated: Bool, onNavigateBack: NavigationBackHandler?)
    func pop()
    func popToRoot(animated: Bool)
    func popToViewController(_ controller: UIViewController, animated: Bool)

    func present(_ drawable: Drawable)
    func present(_ drawable: Drawable, animated: Bool)
    func swapStack(with controller: UIViewController, animated: Bool)
    func dismiss()
    func dismiss(animated: Bool, completion: VoidHandler?)

    func showNavigation(animated: Bool)
    func hideNavigation(animated: Bool)
}

public class Router: NSObject, RouterProtocol {

    public let navigationController: UINavigationController
    private var handlers: [String: NavigationBackHandler] = [:]

    public init(with navigation: UINavigationController) {
        self.navigationController = navigation
        super.init()
        self.navigationController.delegate = self
    }

    public func push(_ drawable: Drawable,
                     onNavigateBack handler: NavigationBackHandler?) {
        push(drawable, animated: true, onNavigateBack: handler)
    }

    public func push(_ drawable: Drawable,
                     animated: Bool,
                     onNavigateBack handler: NavigationBackHandler?) {

        guard let viewController = drawable.viewController else { return }

        if let handler = handler {
            handlers.updateValue(handler, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: animated)
    }


    public func pop() {
        navigationController.popViewController(animated: true)
    }

    public func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }

    public func popToViewController(_ controller: UIViewController, animated: Bool) {
        navigationController.popToViewController(controller, animated: animated)
    }

    public func present(_ drawable: Drawable) {
        present(drawable, animated: true)
    }

    public func present(_ drawable: Drawable, animated: Bool) {
        guard let viewController = drawable.viewController else { return }
        navigationController.present(viewController, animated: animated, completion: nil)
    }

    public func swapStack(with controller: UIViewController, animated: Bool) {
        navigationController.setViewControllers([controller], animated: animated)
    }

    public func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }

    public func dismiss(animated: Bool, completion: VoidHandler? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    public func showNavigation(animated: Bool) {
        navigationController.setNavigationBarHidden(false, animated: animated)
    }

    public func hideNavigation(animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: animated)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = handlers.removeValue(forKey: viewController.description) else { return }
        closure()
    }

}

extension Router: UINavigationControllerDelegate {

    public var navigationBarHidden: Bool {
        return navigationController.isNavigationBarHidden
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(previousController) else { return }

        executeClosure(previousController)
    }
}

public typealias NavigationBackHandler = (() -> ())

public protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    public var viewController: UIViewController? { return self }
}

