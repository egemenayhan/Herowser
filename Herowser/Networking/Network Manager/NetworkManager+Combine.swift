//
//  NetworkManager+Combine.swift
//
//  Created by Egemen Ayhan on 8.05.2021.
//

#if (arch(arm64) || arch(x86_64))
#if canImport(Combine)
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension NetworkManager {

    public func execute<T: Endpoint>(request: T) -> AnyPublisher<T.Response, NetworkingError> {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.asURLRequest()
        } catch {
            return Fail(error: .parameterEncodingFailed(reason: .jsonEncodingFailed(error: error)))
                .eraseToAnyPublisher()
        }

        Logger.log(request: urlRequest)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let urlResponse = response as? HTTPURLResponse {
                    Logger.log(response: urlResponse, bodyData: data)
                }

                guard 200..<300 ~= response.httpStatusCode else {
                    throw NetworkingError.connectionError(response.filterStatusCode(with: data))
                }

                if T.Response.self == String.self || T.Response.self == Optional<String>.self,
                   let stringResponse = String(data: data, encoding: .utf8) as? T.Response {
                    return stringResponse
                }
                let response = try JSONDecoder().decode(T.Response.self, from: data)
                return response
            }
            .mapError { error in
                switch error {
                case let error as DecodingError:
                    return .decodingFailed(error)
                case let error as NetworkingError:
                    return error
                default:
                    return .undefined
                }
            }
            .eraseToAnyPublisher()
    }

}
#endif
#endif
