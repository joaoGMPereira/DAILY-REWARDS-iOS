//
//  EditChallengePresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit

protocol EditChallengePresenterProtocol {
    func presentGoalReachSelectedButton(totalIndex: Int, selectedIndex: Int)
    func presentPeriodSelectedButton(totalIndex: Int, selectedIndex: Int)
    func presentGoalReach(isOn: Bool)
    func presentReward(isOn: Bool)
    func presentRewardSelectedButton(totalIndex: Int, selectedIndex: Int)
}

class EditChallengePresenter: EditChallengePresenterProtocol {
    
    weak var viewController: EditChallengeViewControllerProtocol?
    
    func presentGoalReachSelectedButton(totalIndex: Int, selectedIndex: Int) {
        viewController?.displayRecurrency(selectedIndex: selectedIndex)
    }
    
    func presentPeriodSelectedButton(totalIndex: Int, selectedIndex: Int) {
        viewController?.displayPeriod(selectedIndex: selectedIndex)
        if selectedIndex == 0 {
            viewController?.hideRecurrency()
        } else {
            viewController?.displayRecurrency()
        }
    }
    
    func presentGoalReach(isOn: Bool) {
        isOn ? viewController?.displayGoalReach() : viewController?.displayInfinityGoalReach()
    }
    
    func presentReward(isOn: Bool) {
        isOn ? viewController?.displayReward() : viewController?.displayNoReward()
    }
    
    func presentRewardSelectedButton(totalIndex: Int, selectedIndex: Int) {
        viewController?.displayRewardType(selectedIndex: selectedIndex)
    }
}
