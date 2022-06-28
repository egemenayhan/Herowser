//
//  HeroTableViewCell.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import UIKit
import Kingfisher

class HeroTableViewCell: UITableViewCell {

    static var reuseIdentifier = String(describing: HeroTableViewCell.self)

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        heroImageView.kf.cancelDownloadTask()
        heroImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
    }

    func configureUI(hero: Hero) {
        if let path = hero.thumbnail?.portraitPath {
            heroImageView.kf.setImage(with: URL(string: path))
        }

        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
        descriptionLabel.isHidden = hero.description?.isEmpty ?? true
    }

}

