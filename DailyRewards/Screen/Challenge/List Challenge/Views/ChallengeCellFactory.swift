//
//  ChallengeCell.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 02/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import UIKit
import JewFeatures

class ChallengeCellFactory {
    
    static func cellIdentifier(cellType: ChallengeCellType) -> String {
        switch cellType {
        case .NewChallenge:
            return String(describing: type(of: ChallengeNewCell.self))
        case .Challenge:
            return String(describing: type(of: ChallengeInfoCell.self))
        }
    }
}
