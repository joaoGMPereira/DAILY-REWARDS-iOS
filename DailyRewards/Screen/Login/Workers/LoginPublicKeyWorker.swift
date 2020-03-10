//
//  LoginPublicKeyWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 27/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

typealias LoginPublicKeySuccess = ((HTTPResponse<HTTPPublicKey>) -> Void)
typealias LoginPublicKeyError = ((_ error: ConnectorError) -> Void)

protocol LoginPublicKeyWorkerProtocol {
    func get(successCompletion: @escaping LoginPublicKeySuccess, errorCompletion: @escaping LoginPublicKeyError)
}

class LoginPublicKeyWorker: NSObject, LoginPublicKeyWorkerProtocol {
    func get(successCompletion: @escaping LoginPublicKeySuccess, errorCompletion: @escaping LoginPublicKeyError) {
        JEWConnector.connector.request(withRoute: "/public-key", method: .get, responseClass: HTTPResponse<HTTPPublicKey>.self, successCompletion: { (decodable) in
            guard let responsePublicKey = decodable as? HTTPResponse<HTTPPublicKey> else {
                errorCompletion(ConnectorError.handleError(error: ConnectorError.customError()))
                return
            }
            successCompletion(responsePublicKey)
        }) { (error) in
            errorCompletion(error)
        }
    }

}
