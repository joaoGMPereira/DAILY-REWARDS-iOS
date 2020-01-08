//
//  ContentView.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 10/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct ListCardsView: View {
    
    private static let cardTransitionDelay: Double = 0.2
    private static let cardOffset: CGFloat = -20
    private static let cardOpacity: Double = 0.05
    private static let cardShrinkRatio: CGFloat = 0.05
    private static let cardRotationAngle: Double = 30
    private static let cardScaleWhenDragginDown: CGFloat = 1.1
    private static let padding: CGFloat = 20
    
    @EnvironmentObject var list: List
    @State var draggingOffset: CGPoint = .zero
    @State var isDragging: Bool = false
    @State var firstCardScale: CGFloat = Self.cardScaleWhenDragginDown
    @State var isPresented = false
    @State var shouldDelay = true

    var body: some View {
        GeometryReader { geometry in
            ZStack() {
                if self.isPresented {
                    ForEach(self.list.cards) { card in
                        CardView(card: card)
                            .opacity(self.opacity(for: card))
                            .offset(x: 0,
                                    y: self.offsetY(for: card))
                            .scaleEffect(self.scaleEffect(for: card))
                            .rotation3DEffect(self.rotationAngle(for: card),
                                              axis: (x: 0.5, y: 1, z: 0))
                            .gesture(
                                DragGesture()
                                    .onChanged({ (value) in
                                        self.dragGestureDidChange(value: value,
                                                                  card: card,
                                                                  geometry: geometry)
                                    })
                                    .onEnded({ (value) in
                                        self.dragGestureDidEnd(value: value,
                                                               card: card,
                                                               geometry: geometry)
                                    }))
                            .onTapGesture {
                                var addCardArray = [Card]()
                                if let addCard = self.list.cards.last, addCard.isAddCard == true, addCard != card {
                                    addCardArray.append(addCard)
                                    let newCards = addCardArray + self.list.cards.dropLast().filter { $0 != card } + [card]
                                    self.list.cards = newCards
                                } else {
                                    let newCards = self.list.cards.filter { $0 != card } + [card]
                                    self.list.cards = newCards
                                }
                            }
                            .transition(.moveUpWardsWhileFadingIn)
                            .animation(Animation.easeOut.delay(self.transitionDelay(card: card)))
                    }.onAppear {
                        self.shouldDelay = false
                    }
                }
            }
            .onAppear {
                    self.isPresented.toggle()
            }
            .padding(.horizontal, Self.padding)
        }
    }
}

// MARK: Dragging

extension ListCardsView {
    
    func dragGestureDidChange(value: DragGesture.Value, card: Card, geometry: GeometryProxy) {
        guard list.isFirst(card: card) else { return }
            draggingOffset = CGPoint(x: value.translation.width, y: value.translation.height)
            isDragging = true
            firstCardScale = newFirstCardScale(geometry: geometry)
    }
    
    func dragGestureDidEnd(value: DragGesture.Value, card: Card, geometry: GeometryProxy) {
        guard list.isFirst(card: card) else { return }
        draggingOffset = .zero
            list.cards = cardsResortedAfterTranslation(draggedCard: card, yTranslation: value.translation.height, geometry: geometry)
            isDragging = false
    }
    
}

// MARK: Helper functions

extension ListCardsView {
    
    private func cardsResortedAfterTranslation(draggedCard card: Card, yTranslation: CGFloat, geometry: GeometryProxy) -> [Card] {
        let cardHeight = (geometry.size.width / CGFloat(Card.aspectRatio) - Self.padding)
        if abs(yTranslation + CGFloat(list.cards.count) * -Self.cardOffset) > cardHeight {
            
            var addCardArray = [Card]()
            var removableCardArray = self.list.cards
            if let addCard = self.list.cards.first, addCard.isAddCard == true {
                addCardArray.append(addCard)
                removableCardArray = Array(removableCardArray.dropFirst())
            }
            
            let newCards = addCardArray + [card] + Array(removableCardArray.dropLast())
            return newCards
        }
        
        return list.cards
    }
    
    private func newFirstCardScale(geometry: GeometryProxy) -> CGFloat {
        if draggingOffset.y > 0 {
            let newScale = 1 + draggingOffset.y / (1.5 * geometry.size.height)
            return min(Self.cardScaleWhenDragginDown, newScale)
        } else {
            let newScale = 1 + draggingOffset.y / (1.5 * geometry.size.height)
            return max(1 - CGFloat(list.cards.count) * Self.cardShrinkRatio, newScale)
        }
    }
    
    private func transitionDelay(card: Card) -> Double {
        guard shouldDelay else { return 0 }
        return Double(list.index(of: card)) * Self.cardTransitionDelay
    }
    
    private func opacity(for card: Card) -> Double {
        let cardIndex = Double(list.index(of: card))
        return 1 - cardIndex * Self.cardOpacity
    }
    
    private func offsetY(for card: Card) -> CGFloat {
        guard !list.isFirst(card: card) else { return draggingOffset.y }
        let cardIndex = CGFloat(list.index(of: card))
        let multiplier: CGFloat = card.isAddCard ? 1.5 : 1
        return (cardIndex * multiplier) * Self.cardOffset
    }
    
    private func scaleEffect(for card: Card) -> CGFloat {
        guard !(isDragging && list.isFirst(card: card)) else { return firstCardScale }
        let cardIndex = CGFloat(list.index(of: card))
        return 1 - cardIndex * Self.cardShrinkRatio
    }
    
    private func rotationAngle(for card: Card) -> Angle {
        guard !list.isFirst(card: card) && !isDragging else { return .zero }
        if card.isAddCard { return Angle(degrees: Self.cardRotationAngle) }
        return Angle(degrees: Self.cardRotationAngle)
    }
}

extension AnyTransition {
    static var moveUpWardsWhileFadingIn: AnyTransition {
        return AnyTransition.move(edge: .bottom).combined(with: .opacity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListCardsView().environmentObject(List(cards: cards))
    }
}
