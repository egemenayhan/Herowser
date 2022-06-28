//
//  Comic.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import Foundation

struct Comic: Codable {

    var title: String?
    var thumbnail: Thumbnail?
    var dates: [ComicDate]?

    var onsaleDate: String? {
        guard let date = dates?.first(where: { $0.type == .onsale })?.date?.formatServerTime() else { return nil }
        return date.formatForDisplay(with: .yyyy)
    }

}

struct ComicDate: Codable {
    var type: DateType?
    var date: String?
}

enum DateType: String, Codable {
    case onsale = "onsaleDate"
    case unknown
}

extension DateType {
    public init(from decoder: Decoder) throws {
        self = try DateType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
