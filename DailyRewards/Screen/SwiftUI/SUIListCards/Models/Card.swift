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
         descripton: "Descrição do primeiro desafio",
         type: .completed,
         leftImageName: "mockImage",
         isIndividual: false),
    Card(title: "Segundo desafio",
         descripton: "Descrição do segundo desafio",
         type: .inProgress,
         leftImageName: "mockImage"),
    Card(title: "Terceiro desafio",
         descripton: "Descrição do Terceiro desafio",
         type: .inProgress,
         leftImageName: "mockImage"),
    Card(title: "Quarto desafio",
         descripton: "Descrição do quarto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Quinto desafio",
         descripton: "Descrição do Quinto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Sexto desafio",
         descripton: "Descrição do Sexto desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Setimo desafio",
         descripton: "Descrição do Setimo desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Oitavo desafio",
         descripton: "Descrição do Oitavo desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Nono desafio",
         descripton: "Descrição do Nono desafio",
         type: .canceled,
         leftImageName: "mockImage"),
    Card(title: "Decimo desafio",
         descripton: "Descrição do Decimo desafio",
         type: .canceled,
         leftImageName: "mockImage")
]

let cardNew = [Card(title: "Deseja criar um novo desafio?",
descripton: "Clique no Card para começar a criação",
type: .new,
leftImageName: "add",
isAddCard: true)]

struct Card: Identifiable, Equatable {
    
    static let aspectRatio: Double = 16 / 9
    
    var id: String {
        return title
    }
    var title: String
    var descripton: String
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
}
