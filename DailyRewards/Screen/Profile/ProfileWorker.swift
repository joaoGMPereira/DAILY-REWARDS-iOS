//
//  ProfileWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 27/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation

typealias ProfileSuccess = ((_ response: String) -> Void)
typealias ProfileError = ((_ errorMessage: String) -> Void)

protocol ProfileINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping ProfileSuccess, failure: @escaping ProfileError)
}

class ProfileWorker: NSObject, ProfileINVSSimulatorWorkerProtocol {
    
    func getSomething(success: @escaping ProfileSuccess, failure: @escaping ProfileError) {
        
    }
    
}
