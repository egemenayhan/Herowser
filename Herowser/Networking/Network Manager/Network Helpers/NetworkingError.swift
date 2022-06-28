//
//  NetworkingError.swift
//  DropBeers
//
//  Created by Apple Seed on 14.05.2020.
//  Copyright © 2020 Apple Seed. All rights reserved.
//

/// Error type to be used in Networking module
enum NetworkingError: Error {

    /// Indicates that there has been a connection error to the server
    case connectionError(HTTPError)

    /// Indicates that parsing is not possible with the current data and
    /// given type to parse into.
    case decodingFailed(DecodingError)

    /// `ParameterEncoding` threw an error during the encoding process.
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)

    /// In case an error occures which is not identified
    case undefined

    var description: String? {
        var message: String?
        switch self {
        case .connectionError(let error):
            message = error.errorDescription
        case .decodingFailed(let error):
            message = error.localizedDescription
        case .parameterEncodingFailed(let reason):
            message = reason.description
        case .undefined:
            message = "undefined"
        }
        return message
    }

    public enum ParameterEncodingFailureReason {
        /// The `URLRequest` did not have a `URL` to encode.
        case missingURL
        /// JSON serialization failed with an underlying system error during the encoding process.

        case jsonEncodingFailed(error: Error)

        /// Custom parameter encoding failed due to the associated `Error`.
        case customEncodingFailed(error: Error)

        var description: String {
            switch self {
            case .missingURL:
                return "URL request to encode was missing a URL"
            case let .jsonEncodingFailed(error):
                return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
            case let .customEncodingFailed(error):
                return "Custom parameter encoder failed with error: \(error.localizedDescription)"
            }
        }

        var localizedDescription: String {
            switch self {
            case .missingURL:
                return description
            case let .jsonEncodingFailed(error):
                return error.localizedDescription
            case let .customEncodingFailed(error):
                return error.localizedDescription
            }
        }
    }


}
