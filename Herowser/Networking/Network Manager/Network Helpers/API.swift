//
//  API.swift
//  DropBeers
//
//  Created by Apple Seed on 14.05.2020.
//  Copyright © 2020 Apple Seed. All rights reserved.
//

/// Represents an environment to connect to
struct API {

    /// Root URL to the environment
    var baseURL: BaseURL

    /// Default header values to be included in every request for this environment
    var headers: [String: String]

    /// Init
    init(baseURL: BaseURL, headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
    }

}
