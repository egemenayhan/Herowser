//
//  HeroComicsRequest.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import Alamofire

struct HeroComicsRequest: MarvelAPIEndpoint {

    typealias Response = BaseResponse<[Comic]>
    var path = "/v1/public/characters"
    var method: HTTPMethod = .get
    var parameters: [String : Any]

    init(heroID: Int) {
        path += "/\(heroID)/comics"
        let timestamp = Date().timeIntervalSince1970
        let currentDateForRange = Date().formatForDisplay(with: .yyyyMMddDashed)
        parameters = [
            "characterId": heroID,
            "dateRange": "2005-01-01," + currentDateForRange,
            "orderBy": "-onsaleDate",
            "limit": 10,
            "offset": 0,
            "apikey": APICredentialGenerator.Constants.publicKey,
            "ts": timestamp,
            "hash": APICredentialGenerator.generate(timeStamp: timestamp)
        ]
    }

}
