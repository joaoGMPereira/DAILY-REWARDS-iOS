//
//  Card.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 10/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

let cards = [
    Card(title: "Primeiro desafio",
         description: "Descrição do primeiro desafio",
         type: .completed,
         leftImageName: "mockImage",
         isIndividual: false),
    Card(title: "Segundo desafio",
         description: "Descrição do segundo desafio",
         type: .inProgress,
         leftImageName: "mockImage"),
    Card(title: "Terceiro desafio",
         description: "Descrição do Terceiro desafio",
         type: .inProgress,
         leftImageName: "mockImage"),
    Card(title: "Quarto desafio",
         description: "Descrição do quarto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Quinto desafio",
         description: "Descrição do Quinto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Sexto desafio",
         description: "Descrição do Sexto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Setimo desafio",
         description: "Descrição do Setimo desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Oitavo desafio",
         description: "Descrição do Oitavo desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Nono desafio",
         description: "Descrição do Nono desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Decimo desafio",
         description: "Descrição do Decimo desafio",
         type: .canceled,
         leftImageName: "mockImage")
]

let cardNew = [Card(title: "Deseja criar um novo desafio?",
description: "Clique no Card para começar a criação",
type: .new,
leftImageName: "add",
isAddCard: true)]

class Card: ObservableObject, Equatable, Identifiable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        let firstCardId = lhs.id
        let firstCardTitle = lhs.title
        let firstCardDescription = lhs._description
        let secondCardId = rhs.id
        let secondCardTitle = rhs.title
        let secondCardDescription = rhs._description
        return firstCardId == secondCardId && firstCardTitle == secondCardTitle && firstCardDescription == secondCardDescription
    }
    

    
    static let aspectRatio: Double = 16 / 9
    
    var id: String {
        return title
    }
    var title: String
    var _description: String
    var status: String {
        return type.statusText
    }
    var type: CardType
    var leftImageName: String
    var rightImageName: String {
        return "person"
    }
    var isIndividual: Bool = true
    var isAddCard: Bool = false
    @Published var isLoading: ViewState = .loaded
    
    init(title: String, description: String, type: CardType, leftImageName: String, isIndividual: Bool = true, isAddCard: Bool = false, isLoading: ViewState = .loaded) {
        self.title = title
        self._description = description
        self.type = type
        self.leftImageName = leftImageName
        self.isIndividual = isIndividual
        self.isAddCard = isAddCard
        self.isLoading = isLoading
    }
}
