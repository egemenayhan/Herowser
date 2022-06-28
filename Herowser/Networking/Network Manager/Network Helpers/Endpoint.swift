//
//  Endpoint.swift
//  DropBeers
//
//  Created by Apple Seed on 14.05.2020.
//  Copyright © 2020 Apple Seed. All rights reserved.
//

import Alamofire

/// Holds all the information to build a request
protocol Endpoint: URLRequestConvertible {

    /// A response type should be defined with every `Endpoint` implementation
    /// This type will be used to parse the response into concrete types
    associatedtype Response: Decodable

    /// The API definition this endpoint belongs to
    var api: API { get }

    /// Path component for this endpoint
    var path: String { get }

    /// HTTP method this endpoint uses
    var method: HTTPMethod { get }

    /// Parameters will be parsed based on the HTTP method
    /// For `GET` it will be URL encoding and for `POST` it will be HTTP body JSON encoding
    var parameters: [String: Any] { get }

    /// Any additional header values that should be added along with default header
    /// values defined in `API`
    /// Users can override default header values of API using the same keys
    var additionalHeaders: [String: String] { get }

    func apiForEnvironment( _ environment: Environment) -> API
    var encoding: ParameterEncoding { get }
    var contentType: ContentType { get }
    var task: HTTPTask { get }

}

// MARK: - Default values

extension Endpoint {

    var api: API {
        return apiForEnvironment(Global.environment)
    }

    /// Return an empty dictionary for parameters
    var parameters: [String: Any] { return [:] }

    /// Return an empty dictionary for additional header values
    var additionalHeaders: [String: String] { return [:] }

    var contentType: ContentType { return .applicationJson } // default
    var task: HTTPTask { return .requestParameters(bodyParameters: parameters) } // default

    var encoding: ParameterEncoding {
        switch method {
        case .get, .head, .delete:
            return .urlEncoding
        default:
            return .jsonEncoding
        }
    }

}

// MARK: - URLRequestConvertible

extension Endpoint {

    /// Construct `URLRequest`
    func asURLRequest() throws -> URLRequest {
        // Construct the URL
        var components = URLComponents()
        components.scheme = api.baseURL.scheme
        components.host = api.baseURL.host
        components.path = path
        // This will throw an error if provided information is not correct
        let url = try components.asURL()
        // Create the request and assign appropriate values
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = HeaderBuilder(with: self).build().merging(additionalHeaders, uniquingKeysWith: { $1 })

        // Try to encode request and return it
        switch task {
        case .request: break
        case .requestParameters(let parameters):
            try encoding
                .encode(urlRequest: &request,
                        parameters: parameters)
        }

        return request
    }

}

public enum ContentType: String {
    case xWwwFormEncoded = "application/x-www-form-urlencoded"
    case applicationJson = "application/json"
}

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?)
}
