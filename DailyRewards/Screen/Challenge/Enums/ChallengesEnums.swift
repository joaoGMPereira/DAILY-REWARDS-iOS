//
//  ChallengesEnums.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 03/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit

enum ChallengeType {
    case group
    case individual
}

enum ChallengeStatus: Int, Codable {
    case Completed
    case Canceled
    case InProgress
    
    func message() -> String {
        switch self {
        case .Completed:
            return "Concluído com sucesso! ✅"
        case .Canceled:
            return "Desafio cancelado! ❌"
        case .InProgress:
            return "Em andamento!"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .Completed:
            return .green
        case .Canceled:
            return .JEWRed()
        case .InProgress:
            return .yellow
        }
    }
}

enum ChallengeCellType: Int, Codable {
    case NewChallenge
    case Challenge
}

