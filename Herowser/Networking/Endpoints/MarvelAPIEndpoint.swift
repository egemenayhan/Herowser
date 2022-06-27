//
//  MarvelAPIEndpoint.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

protocol MarvelAPIEndpoint: Endpoint {}

extension MarvelAPIEndpoint {

    func apiForEnvironment(_ environment: Environment) -> API {
        switch environment {
        case .beta, .debug, .prod:
            return API(baseURL: BaseURL(scheme: "https", host: environment.baseURL))
        }
    }
}
