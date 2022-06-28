//
//  Hero.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

struct Hero: Codable {

    var name: String
    var description: String?
    var thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case name, description, thumbnail
    }

}

struct Thumbnail: Codable {

    var path: String?
    var `extension`: String?

}
