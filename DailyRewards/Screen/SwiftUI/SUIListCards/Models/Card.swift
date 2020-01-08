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
         imageName: "mockImage"),
    Card(title: "Segundo desafio",
         descripton: "Descrição do segundo desafio",
         type: .inProgress,
         imageName: "mockImage"),
    Card(title: "Terceiro desafio",
         descripton: "Descrição do terceiro desafio",
         type: .unCompleted,
         imageName: "mockImage"),
    Card(title: "Quarto desafio",
         descripton: "Descrição do quarto desafio",
         type: .canceled,
         imageName: "mockImage"),
    Card(title: "Deseja criar um novo desafio?",
            descripton: "Clique no Card para começar a criação",
            type: .new,
            imageName: "add",
            isAddCard: true)
]

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
    var imageName: String
    var isAddCard: Bool = false
    
}
