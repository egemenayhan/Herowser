//
//  HeroDetailHeaderView.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import UIKit

class HeroDetailHeaderView: UICollectionReusableView {

    static var reuseIdentifier = String(describing: HeroDetailHeaderView.self)

    private var contentStackView = UIStackView()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()

    var actionTapHandler: ((PaginationState)->())?
    private var currentState: PaginationState = .idle

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        contentStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill

        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)

        contentStackView.spacing = 8

        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        titleLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
    }

    func configureUI(hero: Hero) {
        if let path = hero.thumbnail?.landscapePath {
            imageView.kf.setImage(with: URL(string: path))
        }
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
    }

}
