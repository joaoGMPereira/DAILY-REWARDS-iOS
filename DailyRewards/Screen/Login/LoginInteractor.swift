//
//  LoginInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import GoogleSignIn
import FirebaseAuth
import JewFeatures

protocol LoginInteractorProtocol {
    func setupSignIn()
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    var worker: LoginWorkerProtocol? = LoginWorker()
    
    func setupSignIn() {
        let currentUser = Auth.auth().currentUser
        GIDSignIn.sharedInstance()?.delegate = worker as? GIDSignInDelegate
        worker?.successCallback = { (user) in
            self.presenter?.presentLogin(user: user)
        }
        worker?.errorCallback = { (error) in
            self.presenter?.presentLogin(error: error)
        }
        if(currentUser != nil) {
            worker?.create(user: currentUser, success: { (user) in
                JEWSession.session.user = user
                self.presenter?.presentLogin(user: user)
            }, error: { (error) in
                self.presenter?.presentLogin(error: error)
            })
        }
    }
}
