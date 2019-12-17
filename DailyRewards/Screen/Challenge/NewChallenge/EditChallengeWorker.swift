//
//  EditChallengeWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation

typealias EditChallengeSuccess = ((_ response: String) -> Void)
typealias EditChallengeError = ((_ errorMessage: String) -> Void)

protocol EditChallengeINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping EditChallengeSuccess, failure: @escaping EditChallengeError)
}

class EditChallengeWorker: NSObject, EditChallengeINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping EditChallengeSuccess, failure: @escaping EditChallengeError) {
        
    }
    
}
