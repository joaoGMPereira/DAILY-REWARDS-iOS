//
//  LoginWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import JewFeatures

typealias LoginSuccess = ((_ response: JEWUserModel) -> Void)
typealias LoginError = ((_ errorMessage: String) -> Void)

protocol LoginWorkerProtocol {
    var successCallback: LoginSuccess?{ get set }
    var errorCallback: LoginError?{ get set }
    func create(user: User?, success: @escaping LoginSuccess, error: LoginError)
}

class LoginWorker: NSObject, LoginWorkerProtocol, GIDSignInDelegate {
    var successCallback: LoginSuccess?
    var errorCallback: LoginError?
    let userNotLogged = "The user has not signed in before or they have since signed out."
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if !shouldShowError(withError: error) {
            guard let idToken = user.authentication.idToken else {
                return
            } // Safe to send to the server
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credentials) { (authData, error) in
                if !self.shouldShowError(withError: error) {
                    self.create(user: authData?.user, success: { (user) in
                        if let success = self.successCallback {
                            success(user)
                        }
                    }, error: { (user) in
                        self.showError(text: JEWConstants.Default.errorMessage.rawValue)
                    })
                }
                
            }
        }
    }
    
    func create(user: User?, success: @escaping LoginSuccess, error: LoginError) {
        guard let user = user, let email = user.email, let fullName = user.displayName, let photoURL = user.photoURL else {
            self.showError(text: JEWConstants.Default.errorMessage.rawValue)
            return
        }
        user.getIDToken { (token, error) in
            if !self.shouldShowError(withError: error), let token = token {
                success(JEWUserModel(email: email, uid: token, fullName: fullName, photoURL: photoURL))
                return
            }
            self.showError(text: JEWConstants.Default.errorMessage.rawValue)
        }
    }
    
    func shouldShowError(withError error: Error? = nil, text: String? = nil) -> Bool {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                showError(text: error.localizedDescription, log: userNotLogged)
            } else {
                showError(text: error.localizedDescription, log: error.localizedDescription)
            }
            return true
        }
        if let text = text {
            showError(text: text)
            return true
        }
        return false
    }
    
    
    func showError(text: String, log: String? = nil) {
        JEWLogger.error(log ?? text)
        if let errorCallback = errorCallback {
            errorCallback(text)
        }
    }
    
}
