//
//  BaseResponse.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {

    var count: Int?
    var limit: Int?
    var offset: Int?
    var total: Int?
    var results: T?

    var hasNextPage: Bool {
        return ((offset ?? 0) * (limit ?? 0)) < total ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case count, limit, offset, results, total
    }

    enum ParentCodingKeys: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ParentCodingKeys.self)

        let subContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        count = try? subContainer.decode(Int.self, forKey: .count)
        limit = try? subContainer.decode(Int.self, forKey: .limit)
        offset = try? subContainer.decode(Int.self, forKey: .offset)
        total = try? subContainer.decode(Int.self, forKey: .total)
        results = try? subContainer.decode(T.self, forKey: .results)
    }

}
