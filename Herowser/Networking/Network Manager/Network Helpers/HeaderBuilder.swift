//
//  HeaderBuilder.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 23.11.2020.
//

import UIKit

class HeaderBuilder<T: Endpoint> {

    private var endpoint: T

    init(with endpoint: T) {
        self.endpoint = endpoint
    }

    func build() -> [String: String] {
        var headers = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = endpoint.contentType.rawValue

        return headers
    }

}
