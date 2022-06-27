//
//
//  AuthenticationManager.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 22.11.2020.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws {
        
        guard let parameters = parameters else { return }
        
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        } catch {
            throw EncodingError.encodingFailed
        }
    }
    
}
