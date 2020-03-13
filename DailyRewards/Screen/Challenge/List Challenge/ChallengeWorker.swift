//
//  ChallengeWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures
typealias ChallengeTasksSuccess = (() -> ())
typealias ChallengeTasksError = ((_ connectorError: ConnectorError) -> ())
typealias ChallengeImageSuccess = ((_ response: UIImage) -> ())
typealias ChallengeImageError = ((_ errorMessage: String) -> ())

protocol ChallengeWorkerProtocol {
    
    func downloadImage(successCompletion: @escaping ChallengeImageSuccess, errorCompletion: @escaping ChallengeImageError)
    func getTasks(successCompletion: @escaping ChallengeTasksSuccess, errorCompletion: @escaping ChallengeTasksError)
}

class ChallengeWorker: NSObject, ChallengeWorkerProtocol {
    func getTasks(successCompletion: @escaping ChallengeTasksSuccess, errorCompletion: @escaping ChallengeTasksError) {
        JEWConnector.connector.request(withRoute: "/group", method: .get, responseClass: HTTPResponse<HTTPPublicKey>.self, successCompletion: { (decodable) in
//            guard let responsePublicKey = decodable as? HTTPResponse<HTTPPublicKey> else {
//                errorCompletion(ConnectorError.handleError(error: ConnectorError.customError()))
//                return
//            }
            successCompletion()
        }) { (error) in
            errorCompletion(error)
        }
    }
    func downloadImage(successCompletion: @escaping ChallengeImageSuccess, errorCompletion: @escaping ChallengeImageError) {
        if let photoURL = JEWSession.session.user?.photoURL {
            var photoUrlString = photoURL.absoluteString
            photoUrlString.append("?sz=200")
            if let bigPhotoUrl = URL(string: photoUrlString) {
                bigPhotoUrl.downloadImage(success: { (image) in
                    successCompletion(image)
                }, failure: { (error) in
                    errorCompletion(error)
                })
            }
        }
    }
    
}
