//
//  HeroesCoordinator.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

class HeroesCoordinator: NSObject, Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var router: RouterProtocol

    init(with router: RouterProtocol) {
        self.router = router
        super.init()
    }

    func start() {
        let controller = HeroesViewController.instantiate()
        controller.coordinator = self
        controller.viewModel = HeroesViewModel()
        router.push(controller) { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }
    }

    func showHeroDetail(hero: Hero) {
        let detailCoordinator = HeroDetailCoordinator(with: router, hero: hero)
        childCoordinators.append(detailCoordinator)
        detailCoordinator.start()
    }

}
