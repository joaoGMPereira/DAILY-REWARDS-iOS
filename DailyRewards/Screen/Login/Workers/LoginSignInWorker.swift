//
//  LoginSignInWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 04/03/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

typealias LoginSignInSuccess = ((HTTPResponse<SessionTokenModel>) -> Void)
typealias LoginSignInError = ((_ error: ConnectorError) -> Void)

protocol LoginSignInWorkerProtocol {
    func post(accessToken: String, signInEncrypted: String, successCompletion: @escaping LoginSignInSuccess, errorCompletion: @escaping LoginSignInError)
}

struct SessionTokenModel: Codable {
    let sessionToken: String
}

struct SignInModel: Codable, JSONAble {
    let uid: String = UIDevice.current.identifierForVendor?.uuidString ?? String()
    let name: String
    let email: String
    let picture: String
}

class LoginSignInWorker: NSObject, LoginSignInWorkerProtocol {
    func post(accessToken: String, signInEncrypted: String, successCompletion: @escaping LoginSignInSuccess, errorCompletion: @escaping LoginSignInError) {
        JEWConnector.connector.request(withRoute: "/login", method: .post, parameters: HTTPRequest(data: signInEncrypted), responseClass: HTTPResponse<SessionTokenModel>.self, headers: ["access-token" : accessToken], successCompletion: { (decodable) in
            guard let sessionToken = decodable as? HTTPResponse<SessionTokenModel> else {
                errorCompletion((ConnectorError.handleError(error: ConnectorError.customError())))
                return
            }
            successCompletion(sessionToken)
        }) { (error) in
            errorCompletion(error)
        }
    }

}
