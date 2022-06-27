//
//  HeroesViewController.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

class HeroesViewController: UIViewController, Instantiatable {

    weak var coordinator: HeroesCoordinator?
    var viewModel: HeroesViewModel? {
        didSet {
            setupViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.reloadData()
    }

    private func setupViewModel() {
        viewModel?.addChangeHandler(handler: { change in
            print(change)
        })
    }

}
