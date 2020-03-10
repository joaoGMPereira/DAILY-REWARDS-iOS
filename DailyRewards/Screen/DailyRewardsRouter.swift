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
    static func setupStartViewController()
    static func setupLoginViewController()
    static func setupChallengeViewController()
    static func setupProfileViewController(withParentViewController parentViewController: UIViewController, heroImageView: UIView?)
    static func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController)
    static func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge)
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
    
    static func setupStartViewController() {
        let startView = StartView()
        let startViewController = UIHostingController(rootView: startView)
        SceneDelegate.shared.window?.rootViewController = startViewController
        SceneDelegate.shared.window?.makeKeyAndVisible()
        JEWConnector.connector.baseURL = "https://daily-rewards-node-api.herokuapp.com/api/v1"
        checkIfStartHasBeenLoaded(withViewController: startViewController)
        
    }
    
    private static func checkIfStartHasBeenLoaded(withViewController viewController: UIViewController) {
        if viewController.isViewLoaded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupLoginViewController()
            }
        } else {
            checkIfStartHasBeenLoaded(withViewController: viewController)
        }
    }
    
    static func setupLoginViewController() {
        
        let loginView = NewLoginView()
        var options = UIWindow.TransitionOptions()
        options.direction = .toTop
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.JEWBackground())
        SceneDelegate.shared.window?.setRootViewController(UIHostingController(rootView: loginView), options: options)
        
    }
    
    static func setupChallengeViewController() {
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
    
    static func setupNewChallengeViewController(withParentViewController parentViewController: UIViewController) {
        let newChallengeViewController = NewChallengeViewController()
        let newChallengeNavigationController = UINavigationController.init(rootViewController: newChallengeViewController)
        newChallengeNavigationController.modalTransitionStyle = .crossDissolve
        parentViewController.present(newChallengeNavigationController, animated: true, completion: nil)
    }
    
    static func setupEditChallengeViewController(withParentViewController parentViewController: UIViewController, challenge: Challenge) {
        let editChallengeViewController = EditChallengeViewController()
        let editChallengeNavigationController = UINavigationController.init(rootViewController: editChallengeViewController)
        editChallengeNavigationController.modalTransitionStyle = .crossDissolve
        editChallengeNavigationController.hero.isEnabled = true
        editChallengeViewController.challengeImageView.challengeImageButton.hero.id = "\(HeroConstants.challengeImageHero.rawValue)\(challenge.title)"
        parentViewController.present(editChallengeNavigationController, animated: true)
    }
    
    static func setupProfileViewController(withParentViewController parentViewController: UIViewController, heroImageView: UIView?) {
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

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
