//
//  AuthenticationManager.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 22.11.2020.
//

import Foundation

public typealias Parameters = [String: Any]

struct JSON {
    static let encoder = JSONEncoder()
}

public extension Encodable {

    var asParameter: Parameters {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? Parameters ?? [:]
    }

}

protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters?) throws
}

enum EncodingError: String, Error {
    case encodingFailed = "Could not encoded the parameters."
    case missingUrlString = "Could not create url."
    
    var localizedDescription: String { return rawValue }
}

public enum ParameterEncoding {
    
    case noEncoding
    case urlEncoding
    case jsonEncoding
    case formEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       parameters: Parameters?) throws {
        switch self {
        case .noEncoding: break
        case .urlEncoding:
            guard let urlParameters = parameters else { return }
            try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
        case .jsonEncoding:
            guard let bodyParameters = parameters else { return }
            try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
        case .formEncoding:
            guard let bodyParameters = parameters else { return }
            try FORMParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
        }
    }
    
}
