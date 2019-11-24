//
//  InitializationSetup.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import JewFeatures

class InitializationSetup: NSObject {
    
    static func setup() {
        GIDSignIn.sharedInstance().clientID = "824758762408-jpdekfmriacq1j1h1m96bpi81iudcpii.apps.googleusercontent.com"
        JEWUIColor.default.defaultColor = UIColor.JEWPallete(red: 255, green: 140, blue: 44)
        JEWUIColor.default.lightDefaultColor = UIColor.JEWPallete(red: 164, green: 6, blue: 6)
        setupFirebase()
        let router = DailyRewardsRouter()
        router.setupStartViewController()
    }
    
    static func setupFirebase() {
        //        if INVSSession.session.isDev() {
        //            let filePath = Bundle.main.path(forResource: "GoogleServiceInfoDev", ofType: "plist")
        //            guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
        //                else { return }
        //            FirebaseApp.configure(options: fileopts)
        //        } else {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
            else { return }
        FirebaseApp.configure(options: fileopts)
        // }
    }
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension InitializationSetup: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}


