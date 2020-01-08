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
    
    static func setup(scene: UIWindowScene?) {
        GIDSignIn.sharedInstance().clientID = "824758762408-jpdekfmriacq1j1h1m96bpi81iudcpii.apps.googleusercontent.com"
        setupColors()
        setupFirebase()
        let router = DailyRewardsRouter()
        router.setupStartViewController(scene: scene)
    }
    
    static func setupColors() {
        JEWUIColor.default.defaultColor = UIColor.JEWPallete(red: 91, green: 201, blue: 250)
        JEWUIColor.default.lightDefaultColor = UIColor.JEWPallete(red: 238, green: 255, blue: 255)
        JEWUIColor.default.darkDefaultColor = UIColor.JEWPallete(red: 2, green: 119, blue: 189)
        JEWUIColor.default.backgroundColor = UIColor.JEWBlack()
        UINavigationBar.appearance().barTintColor = .JEWBackground()
        UINavigationBar.appearance().tintColor = .JEWBackground()
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = .JEWDefault()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.JEWDefault()]
        UITabBar.appearance().backgroundColor = .JEWBackground()
    }
    
    static func setupKeyChain() {
        JEWKeyChainWrapperServiceName.instance.uniqueServiceName = KeychainConstants.dailyRewards.rawValue
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
