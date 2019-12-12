//
//  NewChallengeInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

protocol NewChallengeInteractorProtocol {
    func hasSelectedButton(totalIndex: Int, selectedIndex: Int)
    func changeGoalReach(isOn: Bool)
}

class NewChallengeInteractor: NewChallengeInteractorProtocol {
    var presenter: NewChallengePresenterProtocol?
    var worker: NewChallengeWorker?
    
    func hasSelectedButton(totalIndex: Int, selectedIndex: Int) {
        presenter?.presentSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
    }
    
    func changeGoalReach(isOn: Bool) {
        presenter?.presentGoalReach(isOn: isOn)
    }
}
