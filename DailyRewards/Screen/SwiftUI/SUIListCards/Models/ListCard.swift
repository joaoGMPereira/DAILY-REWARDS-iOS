//
//  Wallet.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 12/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

class ListCard: ObservableObject {
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
        self.limitedCards = cardNew + ListCard.setupLoadingInFirstCard(cards: Array(cards.reversed()[minimumLimitedCardsIndex ..< cardsCount]))
        self.cards = ListCard.setupLoadingInFirstCard(cards: Array(cards.reversed()[0 ..< minimumLimitedCardsIndex]))
        
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
        var indexCard = 0
        if let index = limitedCards.firstIndex(of: card) {
            indexCard = index
        }
        return limitedCards.count - indexCard - 1
    }
    
    func isFirst(ofLimited card: Card) -> Bool {
        return index(ofLimited: card) == 0
    }
    
    func isLast(ofLimited card: Card) -> Bool {
        return index(ofLimited: card) == self.limitedCards.count - 1
    }
    
    static func setupLoadingInFirstCard(cards: [Card]) -> [Card] {
           var updatedCards = [Card]()
           for (index, card) in cards.enumerated() {
               card.isLoading = index == cards.count - 1 ? .loading : .loaded
               updatedCards.append(card)
           }
           return updatedCards
       }
}
