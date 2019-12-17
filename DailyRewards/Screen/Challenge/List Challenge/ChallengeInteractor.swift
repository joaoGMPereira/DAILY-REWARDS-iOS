//
//  ChallengeInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import JewFeatures
import FirebaseAuth

protocol ChallengeInteractorProtocol {
    func downloadProfileImage()
    func setUserName()
    func setMyChallenges()
    func selectedCell(cellType: ChallengeCellType, challenge: Challenge?)
    var myChallenges: [Challenge] {get set}
    var groupChallenges: [Challenge] {get set}
    
}

class ChallengeInteractor: ChallengeInteractorProtocol {
    var presenter: ChallengePresenterProtocol?
    var worker: ChallengeWorkerProtocol? = ChallengeWorker()
    var myChallenges: [Challenge] = []
    var groupChallenges: [Challenge] = []
    func downloadProfileImage() {
        worker?.downloadImage(success: { (image) in
            JEWSession.session.user?.photoImage = image
            self.presenter?.presentProfile(image: image)
        }, failure: { (error) in
            self.presenter?.presentProfile(error: error)
        })
    }
    
    func setUserName() {
        presenter?.presentProfile(name: ChallengeConstants.objectives.rawValue)
    }
    
    func setMyChallenges() {
        myChallenges = ChallengeInteractor.challenges()
        groupChallenges = ChallengeInteractor.groupsChallenges()
    }
    
    func selectedCell(cellType: ChallengeCellType, challenge: Challenge?) {
        switch cellType {
        case .Challenge:
            if let challenge = challenge {
                presenter?.presentDetail(challenge: challenge)
            }
            break
        case .NewChallenge:
            presenter?.presentNew()
            break
        }
    }
    
    static func challenges() -> [Challenge] {
        let challengeObject1 = Challenge.init(title: "Testando objects 1", description: "Estou testa teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Canceled)
        let challengeObject2 = Challenge.init(title: "Testando objects 2", description: "Estou testando objects 2 com mais 2 linha testandooooo", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Completed)
        let challengeObject3 = Challenge.init(title: "Testando objects 3", description: "Estou testando objects 3 com mais 3 linha teste teste teste teste teste teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .InProgress)
        let challengeObject4 = Challenge.init(title: "Testando objects 4", description: "Estou testando objects 1 com mais 1 linha", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .InProgress)
        let challengeObject5 = Challenge.init(title: "Testando objects 5", description: "Estou testando objects 3 com mais 3 linha teste teste teste teste teste teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Completed)
        let challengeObject6 = Challenge.init(title: "", description: "", imageURLString: "", cellType: .NewChallenge, challengeStatus: .Canceled)
        
        return [challengeObject1,challengeObject2,challengeObject3,challengeObject4,challengeObject5,challengeObject6]
    }
    
    static func groupsChallenges() -> [Challenge] {
        let challengeObject1 = Challenge.init(title: "Testando objects 1 Groups", description: "Estou testa teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Canceled)
        let challengeObject2 = Challenge.init(title: "Testando objects 2 Groups", description: "Estou testando objects 2 com mais 2 linha testandooooo", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Completed)
        let challengeObject3 = Challenge.init(title: "Testando objects 3 Groups", description: "Estou testando objects 3 com mais 3 linha teste teste teste teste teste teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .InProgress)
        let challengeObject4 = Challenge.init(title: "Testando objects 4 Groups", description: "Estou testando objects 1 com mais 1 linha", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .InProgress)
        let challengeObject5 = Challenge.init(title: "Testando objects 5 Groups", description: "Estou testando objects 3 com mais 3 linha teste teste teste teste teste teste", imageURLString: Auth.auth().currentUser?.photoURL?.absoluteString ?? "", cellType: .Challenge, challengeStatus: .Completed)
        let challengeObject6 = Challenge.init(title: "", description: "", imageURLString: "", cellType: .NewChallenge, challengeStatus: .Canceled)
        
        return [challengeObject1,challengeObject2,challengeObject3,challengeObject4,challengeObject5,challengeObject6]
    }
    
}
