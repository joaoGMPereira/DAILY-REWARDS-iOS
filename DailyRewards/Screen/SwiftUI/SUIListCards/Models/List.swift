//
//  Wallet.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 12/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class List: ObservableObject {
    @Published var cards: [Card]
        
    init(cards: [Card]) {
        self.cards = cards.reversed()
    }
    
    func index(of card: Card) -> Int {
        return cards.count - cards.firstIndex(of: card)! - 1
    }
    
    func isFirst(card: Card) -> Bool {
        return index(of: card) == 0
    }
    
    func isLast(card: Card) -> Bool {
        return index(of: card) == self.cards.count - 1
    }
}
