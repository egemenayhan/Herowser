//
//  AuthenticationManager.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 22.11.2020.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {

    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws {
        guard let url = urlRequest.url else {
            throw EncodingError.missingUrlString
        }
        
        guard let parameters = parameters else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryItems = [URLQueryItem]()
            parameters.forEach({
                if let parameterArray = $1 as? [Any] {
                    let key = $0
                    parameterArray.forEach { (item) in
                        let queryItem = URLQueryItem(name: key, value: "\(item)")
                        queryItems.append(queryItem)
                    }
                } else {
                    let queryItem = URLQueryItem(name: $0, value: "\($1)")
                    queryItems.append(queryItem)
                }
            })
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        } else {
            return
        }
    }
    
}
