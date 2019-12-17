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
typealias ChallengeSuccess = ((_ response: UIImage) -> Void)
typealias ChallengeError = ((_ errorMessage: String) -> Void)

protocol ChallengeWorkerProtocol {
    
    func downloadImage(success: @escaping ChallengeSuccess, failure: @escaping ChallengeError)
}

class ChallengeWorker: NSObject, ChallengeWorkerProtocol {
    
    func downloadImage(success: @escaping ChallengeSuccess, failure: @escaping ChallengeError) {
        if let photoURL = JEWSession.session.user?.photoURL {
            photoURL.downloadImage(success: { (image) in
                success(image)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
}
