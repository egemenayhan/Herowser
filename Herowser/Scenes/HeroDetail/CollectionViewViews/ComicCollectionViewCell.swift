//
//  ComicCollectionViewCell.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {

    static var reuseIdentifier = String(describing: ComicCollectionViewCell.self)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
    }

    func configureUI(comic: Comic) {
        if let path = comic.thumbnail?.portraitPath {
            imageView.kf.setImage(with: URL(string: path))
        }
        titleLabel.text = comic.title
        yearLabel.text = comic.onsaleDate
    }

}
