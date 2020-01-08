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

protocol DailyRewardsRouterProtocol: class {
    func setupStartViewController(scene: UIWindowScene?)
    func setupLoginViewController(scene: UIWindowScene?)
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
    
    func setupStartViewController(scene: UIWindowScene?) {
        if let windowScene = scene {
            let startView = StartView()
            let window = UIWindow(windowScene: windowScene)
            let startViewController = UIHostingController(rootView: startView)
            window.rootViewController = startViewController
            SceneDelegate.shared.window = window
            window.makeKeyAndVisible()
            checkIfStartHasBeenLoaded(withViewController: startViewController, scene: scene)
        }
        
    }
    
    private func checkIfStartHasBeenLoaded(withViewController viewController: UIViewController, scene: UIWindowScene?) {
        if viewController.isViewLoaded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupLoginViewController(scene: scene)
            }
        } else {
            checkIfStartHasBeenLoaded(withViewController: viewController, scene: scene)
        }
    }
    
    func setupLoginViewController(scene: UIWindowScene?) {
        
        if let windowScene = scene {
            let loginView = NewLoginView()
            let window = UIWindow(windowScene: windowScene)
            SceneDelegate.shared.window = window
            var options = UIWindow.TransitionOptions()
            options.direction = .toTop
            options.duration = 0.4
            options.style = .easeOut
            options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBackground())
            window.setRootViewController(UIHostingController(rootView: loginView), options: options)
        }
        
    }
    
    func setupChallengeViewController() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let windowScene = windowScene {
            let loginView = NewLoginView()
            let window = UIWindow(windowScene: windowScene)
            let challengeViewController = ChallengeViewController()
            
            var options = UIWindow.TransitionOptions()
            options.direction = .toBottom
            options.duration = 0.4
            options.style = .easeOut
            options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBackground())
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                window.setRootViewController(challengeViewController, options: options)
            }
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
