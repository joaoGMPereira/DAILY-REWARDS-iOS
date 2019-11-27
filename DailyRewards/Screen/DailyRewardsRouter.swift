//
//  LoginRouter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
protocol DailyRewardsRouterProtocol: class {
    func setupStartViewController()
    func setupLoginViewController()
    func setupChallengeViewController()
}

class DailyRewardsRouter: NSObject, DailyRewardsRouterProtocol {
    
    func setupStartViewController() {
        let appDelegate = InitializationSetup.appDelegate()
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        let startViewController = UIViewController()
        startViewController.view.backgroundColor = UIColor.JEWBlack()
        
        appDelegate.window?.rootViewController = startViewController
        appDelegate.window?.makeKeyAndVisible()
        checkIfStartHasBeenLoaded(withViewController: startViewController)
    }
    
    private func checkIfStartHasBeenLoaded(withViewController viewController: UIViewController) {
        if viewController.isViewLoaded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupLoginViewController()
            }
        } else {
            checkIfStartHasBeenLoaded(withViewController: viewController)
        }
    }
    
    func setupLoginViewController() {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let loginViewController = LoginViewController.init(nibName: LoginViewController.toString(), bundle: Bundle.main)
        
        var options = UIWindow.TransitionOptions()
        options.direction = .toTop
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBlack())
        window.setRootViewController(loginViewController, options: options)
        
    }
    
    func setupChallengeViewController() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let challengeViewController = ChallengeViewController.init(nibName: ChallengeViewController.toString(), bundle: Bundle.main)
        
        var options = UIWindow.TransitionOptions()
        options.direction = .toBottom
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBlack())
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            window.setRootViewController(challengeViewController, options: options)
        }
        
    }
    
}
