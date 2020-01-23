//
//  NewChallengeViewController.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 17/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import JewFeatures

protocol NewListChallengeViewControllerDelegate {
   func displayProfile(image: UIImage)
    func displayProfile(name: String)
    func displayProfile(error: String)
    func displayNew()
    func displayDetail(challenge: Challenge)
}

protocol NewListChallengeViewControllerProtocol: class {
   func displayProfile(image: UIImage)
    func displayProfile(name: String)
    func displayProfile(error: String)
    func displayNew()
    func displayDetail(challenge: Challenge)
}

class NewListChallengeViewController: NSObject {
    var interactor: ChallengeInteractorProtocol?
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    var delegate: NewListChallengeViewControllerDelegate?
    init(withDelegate delegate: NewListChallengeViewControllerDelegate) {
        super.init()
        setup(delegate: delegate)
    }
    //MARK: Setup
    func setup(delegate: NewListChallengeViewControllerDelegate) {
        self.delegate = delegate
        let interactor = ChallengeInteractor()
        self.interactor = interactor
        let presenter = ChallengePresenter()
        presenter.viewController = self
        interactor.presenter = presenter
        interactor.downloadProfileImage()
        interactor.setUserName()
        
    }
}


extension NewListChallengeViewController: NewListChallengeViewControllerProtocol {
    
    func displayProfile(image: UIImage) {
        delegate?.displayProfile(image: image)
    }
    
    func displayProfile(error: String) {
        delegate?.displayProfile(error: error)
    }
    
    func displayProfile(name: String) {
        delegate?.displayProfile(name: name)
    }
    
    func displayNew() {
    }
    
    func displayDetail(challenge: Challenge) {
    }
}
