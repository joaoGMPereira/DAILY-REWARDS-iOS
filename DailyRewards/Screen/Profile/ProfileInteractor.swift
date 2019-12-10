//
//  ProfileInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 27/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import JewFeatures
import FirebaseAuth
protocol ProfileInteractorProtocol {
    func setInfo()
    func signOut()
    func vote(index: Int)
    func biometric(isOn: Bool)
}

class ProfileInteractor: ProfileInteractorProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var worker: ProfileWorker?
    
    func setInfo() {
        presenter?.presentProfile(name: JEWSession.session.user?.fullName ?? String())
        presenter?.presentProfile(email: JEWSession.session.user?.email ?? String())
        presenter?.presentProfile(image: JEWSession.session.user?.photoImage ?? UIImage())
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            JEWKeyChainWrapper.clear()
            presenter?.presentSignOut()
        } catch let signOutError as NSError {
            JEWLogger.error("Error signing out: \(signOutError)")
        }
    }
    
    func vote(index: Int) {
        presenter?.presentVote(index: index)
    }
    
    func biometric(isOn: Bool) {
        if isOn {
            presenter?.presentBiometricOn()
            return
        }
        presenter?.presentBiometricOff()
    }
    
}
