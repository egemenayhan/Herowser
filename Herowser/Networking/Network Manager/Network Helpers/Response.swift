//
//  Response.swift
//  DropBeers
//
//  Created by Apple Seed on 14.05.2020.
//  Copyright © 2020 Apple Seed. All rights reserved.
//

import Foundation

/// Holds all response related information
struct Response<Value> {

    /// The request object that this response belongs to
    let request: URLRequest?

    /// HTTP response data for the request
    let response: HTTPURLResponse?

    /// Raw response data for the request
    let data: Data?

    /// Parsed response value for the given type
    let result: Result<Value, NetworkingError>

}
