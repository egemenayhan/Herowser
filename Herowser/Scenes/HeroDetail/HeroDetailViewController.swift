//
//  HeroDetailViewController.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

class HeroDetailViewController: UIViewController, Instantiatable {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var coordinator: HeroDetailCoordinator?
    var viewModel: HeroDetailViewModel? {
        didSet {
            setupViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        viewModel?.fetchDetails()
    }

    private func setupViewModel() {
        viewModel?.addChangeHandler(handler: { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .comicsFetched:
                self.collectionView.reloadData()
            case .loading:
                let activityView = UIActivityIndicatorView()
                activityView.startAnimating()
                activityView.style = .large
                self.collectionView.backgroundView = activityView
            case .loaded:
                if self.viewModel?.state.comics?.isEmpty ?? true {
                    self.setCollectionViewEmptyMessage("No comincs found...")
                } else {
                    self.collectionView.backgroundView = nil
                }
            }
        })
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout =  makeCollectionLayout()

        collectionView.register(
            HeroDetailHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeroDetailHeaderView.reuseIdentifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .estimated(300))

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(300))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 2)
            group.interItemSpacing = .fixed(8)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                            leading: 16,
                                                            bottom: 8,
                                                            trailing: 16)
            let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(300.0))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }

    private func setCollectionViewEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        collectionView.backgroundView = messageLabel;
    }

}

extension HeroDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.state.comics?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? ComicCollectionViewCell else { return UICollectionViewCell() }

        if let item = viewModel?.state.comics?[indexPath.row] {
            cell.configureUI(comic: item)
        }

        return cell
    }

}

extension HeroDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeroDetailHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? HeroDetailHeaderView,
                let hero = viewModel?.state.hero else { return UICollectionReusableView() }
            headerView.configureUI(hero: hero)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }

}
