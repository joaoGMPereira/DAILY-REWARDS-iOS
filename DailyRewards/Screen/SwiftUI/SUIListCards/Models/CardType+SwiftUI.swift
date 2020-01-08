//
//  CardBrand+SwiftUI.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 12/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import SwiftUI

extension CardType {
    var logoName: String {
        switch self {
        case .completed:
            return "visa-logo"
        case .inProgress:
            return "mastercard-logo"
        case .unCompleted:
            return "american-express-logo"
        case .canceled:
            return "maestro-logo"
        case .new:
            return "maestro-logo"
        }
    }
    
    var statusText: String {
        switch self {
        case .completed:
            return "Completado"
        case .inProgress:
            return "Em Progresso"
        case .unCompleted:
            return "Incompleto"
        case .canceled:
            return "Cancelado"
        case .new:
            return "Não Iniciado"
        }
    }
    
    var shadowColor: Color {
        return .gray
    }
    
    var highlightedColor: Color {
        switch self {
        case .completed:
            return .white
        case .inProgress:
            return .white
        case .unCompleted:
            return .white
        case .canceled:
            return .white
        case .new:
            return .white
        }
    }
    
    var gradient: Gradient {
        switch self {
        case .completed:
            return Gradient(colors: [
                .green,
                .white])
        case .inProgress:
            return Gradient(colors: [
                .yellow,
                .white])
        case .unCompleted:
            return Gradient(colors: [
                .orange,
                .white])
        case .canceled:
            return Gradient(colors: [
                .red,
                .white])
        case .new:
            return Gradient(colors: [
                .blue,
            .white])
        }
    }
    
    var firstColor: Color {
        switch self {
        case .completed:
            return .green
        case .inProgress:
            return .yellow
        case .unCompleted:
            return.orange
        case .canceled:
            return.red
        case .new:
            return .clear
        }
    }
}
