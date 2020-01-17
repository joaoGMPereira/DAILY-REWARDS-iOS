//
//  Wallet.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 12/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class List: ObservableObject {
    @Published var cards = [Card]()
    @Published var limitedCards = [Card]()
    init(cards: [Card], showLimit: Int? = nil) {
        let cardsCount = cards.count
        var minimumLimitedCardsIndex = 0
        if let showLimit = showLimit {
            minimumLimitedCardsIndex = cardsCount-showLimit
            if minimumLimitedCardsIndex < 0 {
                minimumLimitedCardsIndex = 0
            }
        }
        self.limitedCards = cardNew + Array(cards.reversed()[minimumLimitedCardsIndex ..< cardsCount])
        self.cards = Array(cards.reversed()[0 ..< minimumLimitedCardsIndex])
        
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
    
    func index(ofLimited card: Card) -> Int {
        return limitedCards.count - limitedCards.firstIndex(of: card)! - 1
    }
    
    func isFirst(ofLimited card: Card) -> Bool {
        return index(ofLimited: card) == 0
    }
    
    func isLast(ofLimited card: Card) -> Bool {
        return index(ofLimited: card) == self.limitedCards.count - 1
    }
}
