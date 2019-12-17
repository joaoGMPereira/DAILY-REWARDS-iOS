//
//  EditChallengeInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

protocol EditChallengeInteractorProtocol {
    func changeGoalHasSelectedButton(totalIndex: Int, selectedIndex: Int)
    func periodHasSelectedButton(totalIndex: Int, selectedIndex: Int)
    func changeGoalReach(isOn: Bool)
    func changeReward(isOn: Bool)
    func rewardHasSelectedButton(totalIndex: Int, selectedIndex: Int)
}

class EditChallengeInteractor: EditChallengeInteractorProtocol {

    var presenter: EditChallengePresenterProtocol?
    var worker: EditChallengeWorker?
    
    func changeGoalHasSelectedButton(totalIndex: Int, selectedIndex: Int) {
        presenter?.presentGoalReachSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
    }
    
    func periodHasSelectedButton(totalIndex: Int, selectedIndex: Int) {
        presenter?.presentPeriodSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
    }
    
    func changeGoalReach(isOn: Bool) {
        presenter?.presentGoalReach(isOn: isOn)
    }
    
    func changeReward(isOn: Bool) {
        presenter?.presentReward(isOn: isOn)
    }
    
    func rewardHasSelectedButton(totalIndex: Int, selectedIndex: Int) {
        presenter?.presentRewardSelectedButton(totalIndex: totalIndex, selectedIndex: selectedIndex)
    }
}
