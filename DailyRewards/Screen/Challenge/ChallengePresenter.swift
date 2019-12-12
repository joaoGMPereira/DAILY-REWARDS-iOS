//
//  ChallengePresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit
import JewFeatures
protocol ChallengePresenterProtocol {
    func presentProfile(image: UIImage)
    func presentProfile(error: String)
    func presentProfile(name: String)
    func presentNew()
    func presentDetail(challenge: Challenge)
}

class ChallengePresenter: ChallengePresenterProtocol {

    weak var viewController: ChallengeViewControllerProtocol?
    
    func presentProfile(image: UIImage) {
        viewController?.displayProfile(image: image)
    }
    
    func presentProfile(error: String) {
        viewController?.displayProfile(error: error)
    }
    
    func presentProfile(name: String) {
        viewController?.displayProfile(name: name.capitalized)
    }
    
    func presentNew() {
        viewController?.displayNew()
    }
    
    func presentDetail(challenge: Challenge) {
        viewController?.displayDetail(challenge: challenge)
    }
    
}
