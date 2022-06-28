//
//  HeroDetailCoordinator.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import UIKit

class HeroDetailCoordinator: NSObject, Coordinator {

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var router: RouterProtocol
    var hero: Hero

    init(with router: RouterProtocol, hero: Hero) {
        self.router = router
        self.hero = hero
        super.init()
    }

    func start() {
        let controller = HeroDetailViewController.instantiate()
        controller.coordinator = self
        controller.viewModel = HeroDetailViewModel(state: HeroDetailState(hero: hero))
        router.push(controller) { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }
    }

}
