//
//  ChallengePresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit

protocol ChallengePresenterProtocol {
    func presentProfile(image: UIImage)
    func presentProfile(error: String)
}

class ChallengePresenter: ChallengePresenterProtocol {

    weak var viewController: ChallengeViewControllerProtocol?
    
    func presentProfile(image: UIImage) {
        viewController?.displayProfile(image: image)
    }
    
    func presentProfile(error: String) {
        viewController?.displayProfile(error: error)
    }
    
}
