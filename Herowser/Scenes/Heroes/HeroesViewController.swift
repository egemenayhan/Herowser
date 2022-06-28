//
//  HeroesViewController.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit
import Kingfisher

class HeroesViewController: UIViewController, Instantiatable {

    @IBOutlet private weak var tableView: UITableView!

    weak var coordinator: HeroesCoordinator?
    var viewModel: HeroesViewModel? {
        didSet {
            setupViewModel()
        }
    }
    private var refreshControl = UIRefreshControl()
    private lazy var paginationView = {
        return PaginationView(frame: CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: 80
        ))
    }()
    private lazy var emptyView: UIView = {
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = .center
        emptyLabel.text = "Nothing to see here..."
        return emptyLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
        viewModel?.reloadData()
    }

    private func setupViewModel() {
        viewModel?.addChangeHandler(handler: { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .refreshLoading:
                self.refreshControl.beginRefreshing()
            case .refreshLoaded:
                self.refreshControl.endRefreshing()
            case .paginationLoading:
                self.paginationView.updateUI(state: .paginating)
            case .paginationLoaded:
                let paginationState: PaginationState = self.viewModel?.state.nextPage == nil ? .done : .idle
                self.paginationView.updateUI(state: paginationState)
            case .paginationError:
                self.paginationView.updateUI(state: .fail)
            case .reloaded:
                self.tableView.contentOffset = .zero
                self.tableView.reloadData()
                self.showEmptyViewIfNecessary()
            case .paginated(let range):
                var indexes: [IndexPath] = []
                for index in range {
                    indexes.append(IndexPath(row: index, section: 0))
                }
                self.tableView.insertRows(at: indexes, with: .automatic)
            case .errorOcurred(let error):
                self.showEmptyViewIfNecessary()
                self.showError(message: error)
            case .favoriteStateChanged(let index):
                if let index = index {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                } else {
                    self.tableView.reloadData()
                }
            case .showFavoritesToggled:
                self.paginationView.isHidden = self.viewModel?.showFavorites ?? true
                self.tableView.reloadSections([0], with: .automatic)
                self.updateFavoriteButtonState()
                self.title = (self.viewModel?.showFavorites ?? false) ? "Favorites" : "Herowser"
            }
        })
    }

    private func setupUI() {
        title = "Herowser"

        paginationView.actionTapHandler = { [weak self] (state) in
            guard let self = self else { return }
            switch state {
            case .idle:
                self.viewModel?.nextPage()
            case .fail:
                self.viewModel?.retry()
            default:
                break
            }
        }

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.tableFooterView = paginationView
        tableView.delegate = self
        tableView.rowHeight = 100
    }

    private func setupNavigationBar() {
        updateFavoriteButtonState()
    }

    private func updateFavoriteButtonState() {
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: (viewModel?.showFavorites ?? false) ? "star.fill" : "star"),
            style: .done,
            target: self,
            action: #selector(toggleFavorites)
        )
        barButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = barButton
    }

    @objc private func toggleFavorites() {
        viewModel?.toggleFavorites()
    }

    @objc private func refresh(_ sender: AnyObject) {
        viewModel?.reloadData()
    }

    private func showError(message: String?) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] (_) in
            self?.viewModel?.retry()
        }
        alertController.addAction(retryAction)
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showEmptyViewIfNecessary() {
        guard viewModel?.dataSource.isEmpty ?? true else {
            tableView.backgroundView = nil
            return
        }
        tableView.backgroundView = emptyView
    }

}

extension HeroesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dataSource.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HeroTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? HeroTableViewCell else { return UITableViewCell() }

        if let hero = viewModel?.dataSource[indexPath.row] {
            cell.configureUI(hero: hero)
        }

        return cell
    }

}

extension HeroesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.dataSource.count ?? 0) - 1, !(viewModel?.showFavorites ?? false) {
            viewModel?.nextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let hero = viewModel?.dataSource[indexPath.row] else { return }
        coordinator?.showHeroDetail(hero: hero)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let hero = self.viewModel?.dataSource[indexPath.row] else { return nil }
        let action = UIContextualAction(
            style: .normal,
            title: hero.isFavorite ? "Unfavorite" : "Favorite"
        ) { (_, _, completionHandler) in
            FavoritesManager.shared.toggleFavoriteState(for: hero)
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }

}
