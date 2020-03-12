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
    func showLoading()
    func hideLoading()
    func showError(withTextMessage message:String, title:String, popupType: JEWPopupMessageType, shouldHideAutomatically: Bool)
}

protocol NewLoginViewControllerProtocol {
    func displayShowLoading()
    func displayHideLoading()
    func displayLoginFirebase()
    func displayLogin(user: JEWUserModel)
    func displayLogin(error: String)
}

class NewLoginViewController: NSObject {
    var delegate: NewLoginViewControllerDelegate?
    var interactor: LoginInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    
    init(with delegate: NewLoginViewControllerDelegate) {
        self.delegate = delegate
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
        interactor.setupSignInFirebase()
        
    }
}


extension NewLoginViewController: NewLoginViewControllerProtocol {
    
    func displayShowLoading() {
        delegate?.showLoading()
    }
    
    func displayHideLoading() {
        delegate?.hideLoading()
    }
    
    func displayLoginFirebase() {
        askForBiometric()
    }
    
    func displayLogin(user: JEWUserModel) {
        DailyRewardsRouter.setupChallengeViewController()
    }
    
    func askForBiometric() {
        JEWBiometricsChallenge.checkLoggedUser(keychainKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue, successChallenge: {
            self.interactor?.setupSignInBackend()
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
