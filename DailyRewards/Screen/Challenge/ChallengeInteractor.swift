//
//  ChallengeInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

protocol ChallengeInteractorProtocol {
    func downloadProfileImage()
}

class ChallengeInteractor: ChallengeInteractorProtocol {
    var presenter: ChallengePresenterProtocol?
    var worker: ChallengeWorkerProtocol? = ChallengeWorker()
    
    func downloadProfileImage() {
        worker?.downloadImage(success: { (image) in
            self.presenter?.presentProfile(image: image)
        }, failure: { (error) in
            self.presenter?.presentProfile(error: error)
        })
    }
    
}
