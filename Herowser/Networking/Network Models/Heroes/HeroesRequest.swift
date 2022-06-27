//
//  HeroesRequest.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Alamofire

struct HeroesRequest: MarvelAPIEndpoint {

    typealias Response = BaseResponse<[Hero]>
    var path = "/v1/public/characters"
    var method: HTTPMethod = .get
    var parameters: [String : Any]

    init(page: Int, itemPerPage: Int) {
        let timestamp = Date().timeIntervalSince1970
        parameters = [
            "limit": itemPerPage,
            "offset": page * itemPerPage,
            "apikey": "067c925e89127ec6491de211ee180cb9",
            "ts": timestamp,
            "hash": APICredentialGenerator.generate(timeStamp: timestamp)
        ]
    }

}
