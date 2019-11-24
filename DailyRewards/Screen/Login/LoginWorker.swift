//
//  LoginWorker.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation
import GoogleSignIn
typealias LoginSuccess = ((_ response: String) -> Void)
typealias LoginError = ((_ errorMessage: String) -> Void)

protocol LoginWorkerProtocol {
    var successCallback: LoginSuccess?{ get set }
    var errorCallback: LoginError?{ get set }
}

class LoginWorker: NSObject, LoginWorkerProtocol, GIDSignInDelegate {
    var successCallback: LoginSuccess?
    var errorCallback: LoginError?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if !showError(withError: error) {
        // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
            }
            
            if let success = successCallback {
                success("teste")
            }
        }
    }
    
    func showError(withError error: Error?) -> Bool {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
                if let errorCallback = errorCallback {
                    errorCallback(error.localizedDescription)
                }
            } else {
                print("\(error.localizedDescription)")
                if let errorCallback = errorCallback {
                    errorCallback(error.localizedDescription)
                }
            }
            return true
        }
        return false
    }
    
}
