//
//  ProfilePresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 27/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import Hero

protocol ProfilePresenterProtocol {
    func presentProfile(name: String)
    func presentProfile(email: String)
    func presentProfile(image: UIImage)
    func presentSignOut()
    func presentVote(index: Int)
    func presentBiometricOff()
    func presentBiometricOn()
    
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var viewController: NewProfileViewControllerProtocol?
    
    func presentProfile(name: String) {
        viewController?.displayProfile(name: name)
    }
    
    func presentProfile(email: String) {
        viewController?.displayProfile(email: email)
    }
    
    func presentProfile(image: UIImage) {
        viewController?.displayProfile(image: image)
    }
    
    func presentSignOut() {
        viewController?.displaySignOut()
    }
    
    func presentVote(index: Int) {
        viewController?.displayVote(index: index)
    }
    
    func presentBiometricOn() {
        viewController?.displayBiometricOn()
    }
    
    func presentBiometricOff() {
        viewController?.displayBiometricOff()
    }
    
}
