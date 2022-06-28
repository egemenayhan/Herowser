//
//  Hero.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

struct Hero: Codable {

    var id: Int
    var name: String
    var description: String?
    var thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
    }

    var isFavorite: Bool {
        FavoritesManager.shared.isFavorite(heroID: id)
    }

}

struct Thumbnail: Codable {

    var path: String?
    var `extension`: String?

    var portraitPath: String? {
        if var path = path?.removingPercentEncoding, let ext = `extension` {
            path += "/portrait_medium.\(ext)"
            return path
        }
        return ""
    }

    var landscapePath: String? {
        if var path = path?.removingPercentEncoding, let ext = `extension` {
            path += "/landscape_xlarge.\(ext)"
            return path
        }
        return ""
    }

}
