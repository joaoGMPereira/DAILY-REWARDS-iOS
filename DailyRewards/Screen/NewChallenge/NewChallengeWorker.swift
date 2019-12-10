//
//  NewChallengeWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation

typealias NewChallengeSuccess = ((_ response: String) -> Void)
typealias NewChallengeError = ((_ errorMessage: String) -> Void)

protocol NewChallengeINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping NewChallengeSuccess, failure: @escaping NewChallengeError)
}

class NewChallengeWorker: NSObject, NewChallengeINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping NewChallengeSuccess, failure: @escaping NewChallengeError) {
        
    }
    
}
