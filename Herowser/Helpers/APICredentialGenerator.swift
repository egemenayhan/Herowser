//
//  APICredentialGenerator.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation
import CryptoKit

struct APICredentialGenerator {

    enum Constants {
        static let publicKey = "067c925e89127ec6491de211ee180cb9"
        static let privateKey = "95df70f481102869b47937cfdd00e15c8d3f927e"
    }

    static func generate(timeStamp: TimeInterval = Date().timeIntervalSince1970) -> String {
        return MD5("\(timeStamp)\(Constants.privateKey)\(Constants.publicKey)")
    }

    private static func MD5(_ string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

}
