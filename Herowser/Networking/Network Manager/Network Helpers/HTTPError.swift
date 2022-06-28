//
//  HTTPError.swift
//  BodyTrainer
//
//  Created by Egemen Ayhan on 18.11.2020.
//

import Foundation

public enum HTTPError: Error {
    case badRequest(data: Data?)
    case unauthorized(data: Data?)
    case forbidden(data: Data?)
    case notFound(data: Data?)
    case preconditionFailed(data: Data?)
    case preconditionRequired(data: Data?)
    case tooManyRequest(data: Data?)
    case internalError(data: Data?)

    case noData(data: Data?)
    case undefined(data: Data?)
}

extension HTTPError: LocalizedError {

    init?(statusCode: Int, data: Data?) {
        switch statusCode {
        case 400: self = .badRequest(data: data)
        case 401: self = .unauthorized(data: data)
        case 403: self = .forbidden(data: data)
        case 404: self = .notFound(data: data)
        case 412: self = .preconditionFailed(data: data)
        case 428: self = .preconditionRequired(data: data)
        case 429: self = .tooManyRequest(data: data)
        case 500: self = .internalError(data: data)
        default: return nil
        }
    }

    public var rawValue: String? {
        switch self {
        case .badRequest: return "badRequest"
        case .unauthorized: return "unauthorized"
        case .forbidden: return "forbidden"
        case .notFound: return "notFound"
        case .preconditionFailed: return "preconditionFailed"
        case .preconditionRequired: return "preconditionRequired"
        case .tooManyRequest: return "tooManyRequest"
        case .internalError: return "internalError"
        case .noData: return "noData"
        case .undefined: return "undefined"
        }
    }

    public var code: Int? {
        switch self {
        case .badRequest: return 400
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .preconditionFailed: return 412
        case .preconditionRequired: return 428
        case .tooManyRequest: return 429
        case .internalError: return 500
        default: return nil
        }
    }

    public var data: Data? {
        switch self {
        case .badRequest(let data),
                .unauthorized(let data),
                .notFound(let data),
                .preconditionFailed(let data),
                .preconditionRequired(let data),
                .internalError(let data),
                .forbidden(let data),
                .tooManyRequest(let data),
                .noData(data: let data),
                .undefined(let data):
            return data
        }
    }

    public var response: String? {
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    public var message: String {
        return data?.format()?.message ?? localizedDescription
    }

}

private extension Data {
    func format() -> ErrorBody? {
        return try? JSONDecoder().decode(ErrorBody.self, from: self)
    }
}

public struct ErrorBody: Codable {

    public var success: Bool?
    public var message: String?

}
