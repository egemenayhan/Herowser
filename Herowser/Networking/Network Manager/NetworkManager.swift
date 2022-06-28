//
//  NetworkManager.swift
//  DropBeers
//
//  Created by Apple Seed on 14.05.2020.
//  Copyright © 2020 Apple Seed. All rights reserved.
//

import Alamofire

/// Singleton for all network operations.
final class NetworkManager {

    static let shared = NetworkManager()
    private let session: Session

    // MARK: - Init

    init() {
        session = Session()
    }

    // MARK: - Execute

    @discardableResult func execute<Request: Endpoint>(
        request: Request,
        completion: ((Response<Request.Response>) -> Void)?) -> URLSessionTask? {

        let dataRequest = session.request(request)
        if let urlRequest = try? request.asURLRequest() {
            Logger.log(request: urlRequest)
        }
        dataRequest.validate(statusCode: 200..<300)
        dataRequest.responseData { dataResponse in
            let result: Result<Request.Response, NetworkingError>
            switch dataResponse.result {
            case .success(let data):
                if let response = dataResponse.response {
                    Logger.log(response: response, bodyData: data)
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.serverFormatter)
                    let object = try decoder.decode(Request.Response.self, from: data)
                    result = .success(object)
                } catch let error as DecodingError {
                    result = .failure(NetworkingError.decodingFailed(error))
                } catch {
                    result = .failure(NetworkingError.undefined)
                }
            case .failure(_):
                Logger.logData(bodyData: dataResponse.data)
                if let error = dataResponse.response?.filterStatusCode(with: dataResponse.data) {
                    result = .failure(NetworkingError.connectionError(error))
                    error.handleDefaultErrorIfNeeded()
                } else {
                    result = .failure(NetworkingError.connectionError(HTTPError.undefined(data: nil)))
                }
            }
            completion?(Response<Request.Response>(
                request: dataResponse.request,
                response: dataResponse.response,
                data: dataResponse.data,
                result: result
            ))
        }
        return dataRequest.task
    }

    @discardableResult func downloadFile(from path: String, completion: ((Result<URL, NetworkingError>)->Void)?) -> DownloadRequest {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask, options: [.removePreviousFile])
        return session.download(
            path,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).response(completionHandler: { (response) in
                let result: Result<URL, NetworkingError>
                switch response.result {
                case .success(let fileURL):
                    if let url = fileURL {
                        result = .success(url)
                    } else {
                        result = .failure(.undefined)
                    }
                case .failure(_):
                    result = .failure(.undefined)
                }
                completion?(result)
            }
        )
    }

}

extension HTTPError {

    @discardableResult func handleDefaultErrorIfNeeded() -> Bool {
        switch self {
        default:
        break
        }

        return false
    }

}

extension URLResponse {

    var httpStatusCode: Int {
        return (self as? HTTPURLResponse)?.statusCode ?? 0
    }

    func filterSuccessData(with data: Data?) throws -> Data {
        if let responseData = data {
            return responseData
        } else {
            throw HTTPError.noData(data: nil)
        }
    }

    func filterStatusCode(with data: Data?) -> HTTPError {
        return HTTPError(statusCode: httpStatusCode, data: data) ?? .undefined(data: data)
    }

}
