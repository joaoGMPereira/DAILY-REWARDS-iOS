//
//  LoginRouter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
import Hero

protocol DailyRewardsRouterProtocol: class {
    func setupStartViewController()
    func setupLoginViewController()
    func setupChallengeViewController()
    func setupProfileViewController(withParentViewController parentViewController: UIViewController, heroImageView: UIView?)
    func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController)
    func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge)
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
        let challengeViewController = ChallengeViewController()
        
        var options = UIWindow.TransitionOptions()
        options.direction = .toBottom
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBlack())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            window.setRootViewController(challengeViewController, options: options)
        }
    }
    
    func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController) {
        let newChallengeViewController = NewChallengeViewController.init(nibName: NewChallengeViewController.toString(), bundle: Bundle.main)
        let newChallengeNavigationController = UINavigationController.init(rootViewController: newChallengeViewController)
        newChallengeNavigationController.modalTransitionStyle = .crossDissolve
        parentViewController.present(newChallengeNavigationController, animated: true, completion: nil)
    }
    
    func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge) {
        let newChallengeViewController = NewChallengeViewController.init(nibName: NewChallengeViewController.toString(), bundle: Bundle.main)
        let newChallengeNavigationController = UINavigationController.init(rootViewController: newChallengeViewController)
        newChallengeNavigationController.modalTransitionStyle = .crossDissolve
        newChallengeNavigationController.hero.isEnabled = true
        newChallengeViewController.challengeImageView.challengeImageButton.hero.id = "\(HeroConstants.challengeImageHero.rawValue)\(challenge.title)"
        parentViewController.present(newChallengeNavigationController, animated: true)
    }
    
    func setupProfileViewController(withParentViewController parentViewController: UIViewController, heroImageView: UIView?) {
        let profileViewController = ProfileViewController()
        profileViewController.setup()
        profileViewController.interactor?.setInfo()
        let profileNavigationController = UINavigationController.init(rootViewController: profileViewController)
        profileNavigationController.hero.isEnabled = true
        if let imageHero = heroImageView {
            imageHero.hero.id = HeroConstants.profileImageHero.rawValue
        }
        profileViewController.hero.isEnabled = true
        profileViewController.profileImageView.hero.id = HeroConstants.profileImageHero.rawValue
        parentViewController.present(profileNavigationController, animated: true, completion: nil)
    }
    
}
