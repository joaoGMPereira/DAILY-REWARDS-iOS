//
//  NewChallengePresenter.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import UIKit

protocol NewChallengePresenterProtocol {
    func presentSelectedButton(totalIndex: Int, selectedIndex: Int)
    func presentGoalReach(isOn: Bool)
}

class NewChallengePresenter: NewChallengePresenterProtocol {
    
    weak var viewController: NewChallengeViewControllerProtocol?
    
    func presentSelectedButton(totalIndex: Int, selectedIndex: Int) {
        if selectedIndex == totalIndex - 1 {
            viewController?.displayAllDays(allDaysIndex: selectedIndex)
        } else {
            viewController?.hideAllDays(allDaysIndex: totalIndex - 1)
        }
    }
    
    func presentGoalReach(isOn: Bool) {
        isOn ? viewController?.displayGoalReach() : viewController?.displayInfinityGoalReach()
    }
}
