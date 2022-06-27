//
//  AuthenticationManager.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 22.11.2020.
//

import Foundation

struct FORMParameterEncoder: ParameterEncoder {

    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws {
        var components = URLComponents()
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            parameters.forEach { (arg) in
                let (key, value) = arg
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        
        if let parametersAsString = components.url?.absoluteString.dropFirst() {
            let data = parametersAsString.data(using: .ascii, allowLossyConversion: false)
            urlRequest.httpBody = data
        }
    }
    
}
