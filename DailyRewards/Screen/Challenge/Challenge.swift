//
//  Challenge.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 25/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//

import Foundation

public struct Challenge: Codable {
    var title: String
    var description: String
    var imageURLString: String
    
    var cellType: ChallengeCellType
    var challengeStatus: ChallengeStatus
}
