//
//  RewardType.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 12/12/19.
//  Copyright © 2019 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures

enum RewardType: Int {
    case Money
    case Travel
    case Pizza
    case Hamburguer
    case Beer
    case Reward
    
    func getTitle() -> String {
        switch self {
        case .Money:
            return "Valor Recompensa"
        case .Travel:
            return "Nome Viagem"
        case .Pizza:
            return "Sabor Pizza"
        case .Hamburguer:
            return "Quantos Hamburgueres"
        case .Beer:
            return "Nome Cerveja"
        case .Reward:
            return "Recomensa"
        }
    }
    
    func keyboardType() -> UIKeyboardType {
        switch self {
        case .Money:
            return .numberPad
        case .Travel:
            return .default
        case .Pizza:
            return .default
        case .Hamburguer:
            return .numberPad
        case .Beer:
            return .default
        case .Reward:
            return .default
        }
    }
    
    func valueType() -> JEWFloatingTextFieldValueType {
        switch self {
        case .Money:
            return .currency
        case .Travel:
            return .none
        case .Pizza:
            return .none
        case .Hamburguer:
            return .none
        case .Beer:
            return .none
        case .Reward:
            return .none
        }
    }
}
