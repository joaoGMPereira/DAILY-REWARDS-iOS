//
//  LoginAccessTokenWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 04/03/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

typealias LoginAccessTokenSuccess = ((HTTPResponse<AccessTokenModel>) -> Void)
typealias LoginAccessTokenError = ((_ errorMessage: ConnectorError) -> Void)

protocol LoginAccessTokenWorkerProtocol {
    func post(aesCryptoEncrypted: String, successCompletion: @escaping LoginAccessTokenSuccess, errorCompletion: @escaping LoginAccessTokenError)
}

struct AccessTokenModel: Codable {
    let accessToken: String?
}

class LoginAccessTokenWorker: NSObject, LoginAccessTokenWorkerProtocol {
    func post(aesCryptoEncrypted: String, successCompletion: @escaping LoginAccessTokenSuccess, errorCompletion: @escaping LoginAccessTokenError) {
        JEWConnector.connector.request(withRoute: "/access-token", method: .post, parameters: HTTPRequest(data: aesCryptoEncrypted), responseClass: HTTPResponse<AccessTokenModel>.self, successCompletion: { (decodable) in
            guard let responsePublicKey = decodable as? HTTPResponse<AccessTokenModel> else {
                errorCompletion(ConnectorError.handleError(error: ConnectorError.customError()))
                return
            }
            successCompletion(responsePublicKey)
        }) { (error) in
            errorCompletion(error)
        }
    }

}
