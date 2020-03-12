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

typealias LoginFirebaseSuccess = ((_ response: JEWUserModel) -> Void)
typealias LoginFirebaseError = ((_ errorMessage: ConnectorError) -> Void)

protocol LoginFirebaseWorkerProtocol {
    var successCallback: LoginFirebaseSuccess?{ get set }
    var errorCallback: LoginFirebaseError?{ get set }
    func create(user: User?, success: @escaping LoginFirebaseSuccess, error: LoginFirebaseError)
}

class LoginFirebaseWorker: NSObject, LoginFirebaseWorkerProtocol, GIDSignInDelegate {
    var successCallback: LoginFirebaseSuccess?
    var errorCallback: LoginFirebaseError?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if !shouldShowError(error: error) {
            guard let idToken = user.authentication.idToken else {
                return
            }
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credentials) { (authData, error) in
                if !self.shouldShowError(error: error) {
                    self.create(user: authData?.user, success: { (user) in
                        if let success = self.successCallback {
                            success(user)
                        }
                    }, error: { (error) in
                        self.shouldShowError(error: error)
                    })
                }
            }
        }
    }
    
    func create(user: User?, success: @escaping LoginFirebaseSuccess, error: LoginFirebaseError) {
        guard let user = user, let email = user.email, let fullName = user.displayName, let photoURL = user.photoURL else {
            self.shouldShowError(error: ConnectorError.customError())
            return
        }
        user.getIDToken { (token, error) in
            if !self.shouldShowError(error: error), let token = token {
                success(JEWUserModel(email: email, uid: token, fullName: fullName, photoURL: photoURL))
                return
            }
        }
    }
    
    @discardableResult func shouldShowError(error: Error?) -> Bool {
        if let error = error {
            JEWLogger.error(error.localizedDescription)
            if let errorCallback = self.errorCallback {
                errorCallback(ConnectorError.handleError(error: error))
            }
            return true
        }
        return false
    }
    
    
}
