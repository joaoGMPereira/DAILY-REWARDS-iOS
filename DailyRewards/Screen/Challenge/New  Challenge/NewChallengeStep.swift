//
//  NewChallengeStep.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 16/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation

enum NewChallengeStep: Int {
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    
    
    func moveStep(buttonIndex: Int) -> NewChallengeStepMovement {
        if buttonIndex == 0 {
           return back()
        }
        
        if buttonIndex == 1 {
           return next()
        }
        
        return NewChallengeStepMovement.close(.back)
    }
    
    func back() -> NewChallengeStepMovement {
        switch self {
        case .first:
            return NewChallengeStepMovement.close(.back)
        case .second:
            return NewChallengeStepMovement.first(.back)
        case .third:
            return NewChallengeStepMovement.second(.back)
        case .fourth:
            return NewChallengeStepMovement.third(.back)
        case .fifth:
            return NewChallengeStepMovement.fourth(.back)
        case .sixth:
            return NewChallengeStepMovement.fifth(.back)
        }
    }
    
    func next() -> NewChallengeStepMovement {
        switch self {
        case .first:
            return NewChallengeStepMovement.second(.next)
        case .second:
            return NewChallengeStepMovement.third(.next)
        case .third:
            return NewChallengeStepMovement.fourth(.next)
        case .fourth:
            return NewChallengeStepMovement.fifth(.next)
        case .fifth:
            return NewChallengeStepMovement.sixth(.next)
        case .sixth:
            return NewChallengeStepMovement.finish(.next)
        }
    }
}

enum NewChallengeStepMovement {
    case close(NewChallengeStepMovementDirection)
    case first(NewChallengeStepMovementDirection)
    case second(NewChallengeStepMovementDirection)
    case third(NewChallengeStepMovementDirection)
    case fourth(NewChallengeStepMovementDirection)
    case fifth(NewChallengeStepMovementDirection)
    case sixth(NewChallengeStepMovementDirection)
    case finish(NewChallengeStepMovementDirection)
}

enum NewChallengeStepMovementDirection: Int {
    case back
    case next
}
