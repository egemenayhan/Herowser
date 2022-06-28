//
//  MainCoordinator.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var router: RouterProtocol { get set }

    func start()
}

public extension Coordinator {

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated()
        where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }

}

class MainCoordinator: NSObject, Coordinator {

    var childCoordinators: [Coordinator] = []
    var router: RouterProtocol

    init(with router: RouterProtocol) {
        self.router = router
        super.init()
    }

    func start() {
        finishAllChildren()

        let child = HeroesCoordinator(with: router)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }

    func finishAllChildren() {
        UIApplication.dismissPresentedController()
        childCoordinators = []
    }

}

extension UIApplication {
    public class func dismissPresentedController(_ animated: Bool = false) {
        SceneDelegate.current?.presentedController()?.dismiss(animated: animated, completion: nil)
    }
}
