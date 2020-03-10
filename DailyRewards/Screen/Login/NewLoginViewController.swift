//
//  NewLoginViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 01/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures
import SwiftUI

protocol NewLoginViewControllerDelegate {
    func showError(withTextMessage message:String, title:String, popupType: JEWPopupMessageType, shouldHideAutomatically: Bool)
}

protocol NewLoginViewControllerProtocol {
    func displayLogin(user: JEWUserModel)
    func displayLogin(error: String)
}

class NewLoginViewController: NSObject {
    var delegate: NewLoginViewControllerDelegate?
    var interactor: LoginInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    
    override init() {
        super.init()
        setup()
    }
    //MARK: Setup
    func setup() {
        let interactor = LoginInteractor()
        self.interactor = interactor
        let presenter = LoginPresenter()
        presenter.viewController = self
        interactor.presenter = presenter
        interactor.setupSignIn()
        
    }
}


extension NewLoginViewController: NewLoginViewControllerProtocol {
    func displayLogin(user: JEWUserModel) {
        DailyRewardsRouter.setupChallengeViewController()
       // askForBiometric()
    }
    
    func askForBiometric() {
        JEWBiometricsChallenge.checkLoggedUser(keychainKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue, successChallenge: {
            DailyRewardsRouter.setupChallengeViewController()
        }) { (type) in
            switch type {
            case .default:
                let message = JEWBiometrics.faceIDAvailable() ? BioMetricsFaceIDErrors.kDefaultFaceIDErrorAuthentication.rawValue : BioMetricsTouchIDErrors.kDefaultTouchIDErrorAuthentication.rawValue
                self.delegate?.showError(withTextMessage: message, title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .error, shouldHideAutomatically: false)
                break
            case .error(let error):
                self.delegate?.showError(withTextMessage: error.message(), title: "\(error.title())\n", popupType: .error, shouldHideAutomatically: false)
                break
            case .goSettings(let error):
                 self.delegate?.showError(withTextMessage: error.message(), title: "\(error.title())\n", popupType: .error, shouldHideAutomatically: false)
                break
            }
        }
    }
    
    func displayLogin(error: String) {
        self.delegate?.showError(withTextMessage: error, title: "\(JEWConstants.Default.title.rawValue)\n", popupType: .error, shouldHideAutomatically: false )
    }
}
