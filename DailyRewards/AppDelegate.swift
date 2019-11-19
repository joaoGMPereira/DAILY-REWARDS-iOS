//
//  AppDelegate.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 14/11/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        GIDSignIn.sharedInstance().clientID = "824758762408-jpdekfmriacq1j1h1m96bpi81iudcpii.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        setupLoginViewController()
        // Override point for customization after application launch.
        return true
    }
    
    func setupFirebase() {
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
    
    func setupLoginViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let loginViewController = LoginViewController.init(nibName: "LoginViewController", bundle: Bundle.main)
        
        self.window?.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()

    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            GIDSignIn.sharedInstance().handle
            return GIDSignIn.sharedInstance().handle(url)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: GIDSignInDelegate {
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

