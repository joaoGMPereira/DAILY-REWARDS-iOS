//
//  NewProfileViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 22/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

protocol NewProfileViewControllerDelegate {
   func displayProfile(image: UIImage)
   func displayProfile(email: String)
   func displayProfile(name: String)
   func displaySignOut()
   func displayVote(index: Int)
   func displayBiometricOn()
   func displayBiometricOff()
}

protocol NewProfileViewControllerProtocol: class {
    func displayProfile(image: UIImage)
    func displayProfile(email: String)
    func displayProfile(name: String)
    func displaySignOut()
    func displayVote(index: Int)
    func displayBiometricOn()
    func displayBiometricOff()
}

class NewProfileViewController: NSObject {
    //MARK: Properties
    var interactor: ProfileInteractorProtocol?
    var router = DailyRewardsRouter()
    var delegate: NewProfileViewControllerDelegate?
    init(withDelegate delegate: NewProfileViewControllerDelegate) {
        super.init()
        setup(delegate: delegate)
    }
    
    //MARK: Setup
    func setup(delegate: NewProfileViewControllerDelegate) {
        self.delegate = delegate
        let interactor = ProfileInteractor()
        self.interactor = interactor
        let presenter = ProfilePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
    }
}


extension NewProfileViewController: NewProfileViewControllerProtocol {
    
    func displayProfile(image: UIImage) {
        delegate?.displayProfile(image: image)
    }
    
    func displayProfile(name: String) {
        delegate?.displayProfile(name: name)
    }
    
    func displayProfile(email: String) {
        delegate?.displayProfile(email: email)
    }
    
    func displaySignOut() {
        delegate?.displaySignOut()
        router.setupLoginViewController()
    }
    
    func displayVote(index: Int) {
        delegate?.displayVote(index: index)
    }
    
    func displayBiometricOn() {
        delegate?.displayBiometricOn()
    }
    
    func displayBiometricOff() {
        delegate?.displayBiometricOff()
        //JEWKeyChainWrapper.clear()
    }
    
    private func biometricInfoPopup() {
//        let biometricViewController = INVSAlertViewController()
//        biometricViewController.setup(withHeight: 200, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
//        biometricViewController.titleAlert = JEWConstants.Default.title.rawValue
//        biometricViewController.messageAlert = JEWConstants.EnableBiometricViewController.biometricMessageType()
//        biometricViewController.view.frame = view.bounds
//        biometricViewController.modalPresentationStyle = .overCurrentContext
//        biometricViewController.view.backgroundColor = .clear
//        present(biometricViewController, animated: true, completion: nil)
//        biometricViewController.confirmCallback = { (button) -> () in
//            self.dismiss(animated: true) {
//                JEWKeyChainWrapper.saveBool(withValue: true, andKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
//            }
//        }
//        biometricViewController.cancelCallback = { (button) -> () in
//            if let biometricOption = self.optionViewsArray.first {
//                biometricOption.isOnSwitch.isOn = false
//            }
//        }
    }
}
