//
//  LoginInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import GoogleSignIn

protocol LoginInteractorProtocol {
    func setupSignIn()
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    var worker: LoginWorkerProtocol? = LoginWorker()
    
    func setupSignIn() {
        GIDSignIn.sharedInstance()?.delegate = worker as? GIDSignInDelegate
        worker?.successCallback = { (response) in
            
        }
        worker?.errorCallback = { (error) in
            
        }
    }
}
