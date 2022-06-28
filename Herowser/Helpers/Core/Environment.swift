//
//  Environment.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

enum Environment: String {
    case debug = "Debug"
    case beta = "Beta"
    case prod = "Release"

    var baseURL: String {
        switch self {
        default:
            return "gateway.marvel.com"
        }
    }
}

struct Global {

    static var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            return Environment(rawValue: configuration) ?? .prod
        }

        return Environment.prod
    }()

}
