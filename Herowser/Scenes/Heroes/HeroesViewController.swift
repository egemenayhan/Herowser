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
        viewModel?.reloadData()
    }

    private func setupViewModel() {
        viewModel?.addChangeHandler(handler: { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .refreshLoading:
                self.refreshControl.beginRefreshing()// TODO: programaticallyBeginRefreshing(in: self.tableView)
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
        guard viewModel?.state.heroes.isEmpty ?? true else {
            tableView.backgroundView = nil
            return
        }
        tableView.backgroundView = emptyView
    }

}

extension HeroesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.state.heroes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HeroTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? HeroTableViewCell else { return UITableViewCell() }

        if let hero = viewModel?.state.heroes[indexPath.row] {
            cell.configureUI(hero: hero)
        }

        return cell
    }

}

extension HeroesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.state.heroes.count ?? 0) - 1 {
            viewModel?.nextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let hero = viewModel?.state.heroes[indexPath.row] else { return }
        coordinator?.showHeroDetail(hero: hero)
    }

}
