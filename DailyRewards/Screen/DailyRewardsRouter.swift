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
import SwiftUI
import SwiftyRSA

protocol DailyRewardsRouterProtocol: class {
    func setupStartViewController()
    func setupLoginViewController()
    func setupChallengeViewController()
    func setupProfileViewController(withParentViewController parentViewController: UIViewController, heroImageView: UIView?)
    func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController)
    func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge)
}

struct StartView: View {
    var body: some View {
        ZStack {
            Color.init(UIColor.JEWBlack())
                .edgesIgnoringSafeArea(.all)
        }
    }
}


class DailyRewardsRouter: NSObject, DailyRewardsRouterProtocol {
    
    func setupStartViewController() {
        let startView = StartView()
        let startViewController = UIHostingController(rootView: startView)
        SceneDelegate.shared.window?.rootViewController = startViewController
        SceneDelegate.shared.window?.makeKeyAndVisible()
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
        
        let loginView = NewLoginView()
        var options = UIWindow.TransitionOptions()
        options.direction = .toTop
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBackground())
        SceneDelegate.shared.window?.setRootViewController(UIHostingController(rootView: loginView), options: options)
        
    }
    
    func setupChallengeViewController() {
        let challengeView = NewListChallengeView()
        var options = UIWindow.TransitionOptions()
        options.direction = .toBottom
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBackground())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SceneDelegate.shared.window?.setRootViewController(UIHostingController(rootView: challengeView), options: options)
        }
        
    }
    
    func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController) {
        let newChallengeViewController = NewChallengeViewController()
        let newChallengeNavigationController = UINavigationController.init(rootViewController: newChallengeViewController)
        newChallengeNavigationController.modalTransitionStyle = .crossDissolve
        parentViewController.present(newChallengeNavigationController, animated: true, completion: nil)
    }
    
    func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge) {
        let editChallengeViewController = EditChallengeViewController()
        let editChallengeNavigationController = UINavigationController.init(rootViewController: editChallengeViewController)
        editChallengeNavigationController.modalTransitionStyle = .crossDissolve
        editChallengeNavigationController.hero.isEnabled = true
        editChallengeViewController.challengeImageView.challengeImageButton.hero.id = "\(HeroConstants.challengeImageHero.rawValue)\(challenge.title)"
        parentViewController.present(editChallengeNavigationController, animated: true)
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

//func teste(publicKey: String) -> String {
//        do {
//        let publicKey = try PublicKey(pemEncoded: publicKey)
//            let str = "Clear Text"
//            let clear = try ClearMessage(string: str, using: .utf8)
//            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
//            print(encrypted.base64String)
//            return encrypted.base64String
//        } catch let error {
//            print(error)
//        }
//    }
