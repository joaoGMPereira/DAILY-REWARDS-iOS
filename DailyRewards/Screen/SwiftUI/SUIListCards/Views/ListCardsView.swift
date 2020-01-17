//
//  ContentView.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 10/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

class ListCardsViewModel: ObservableObject {
    @Published var list: List = List(cards: cards, showLimit: 4)
    
    @Published var newPositionOfCards: CGFloat = 0
    @Published var isDraggingDown: Bool = true
}

struct ListCardsView: View {
    
    private static let cardTransitionDelay: Double = 0.2
    private static let cardOffset: CGFloat = -20
    private static let cardOpacity: Double = 0.02
    private static let cardShrinkRatio: CGFloat = 0.03
    private static let cardRotationAngle: Double = 10
    private static let cardScaleWhenDragginDown: CGFloat = 1.1
    private static let padding: CGFloat = 20
    
    @ObservedObject var viewModel: ListCardsViewModel = ListCardsViewModel()
    @State var draggingOffset: CGPoint = .zero
    @State var isDragging: Bool = false
    @State var firstCardScale: CGFloat = Self.cardScaleWhenDragginDown
    @State var isPresented = false
    @State var shouldDelay = true

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center, content: {
                if self.isPresented {
                    ForEach(self.viewModel.list.limitedCards) { card in
                        CardView(card: card)
                            .opacity(self.opacity(for: card))
                            .offset(x: 0,
                                    y: self.viewModel.newPositionOfCards + self.offsetY(for: card))
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
                                self.didTap(card: card)
                            }
                        .transition(self.viewModel.isDraggingDown ? .moveUpWardsWhileFadingIn :.moveDownWardsWhileFadingIn)
                            .animation(Animation.easeOut.delay(self.transitionDelay(card: card)))
                    }.onAppear {
                        self.shouldDelay = false
                    }
                }
            })
            .onAppear {
                    self.isPresented.toggle()
            }
            .padding(.horizontal, Self.padding).edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: Dragging && Tapping

extension ListCardsView {
    
    func didTap(card: Card) {
        var addCardArray = [Card]()
        let changeableList = self.viewModel.list
        if let addCard = changeableList.limitedCards.last, addCard.isAddCard == true, addCard != card {
            addCardArray.append(addCard)
            let newCards = addCardArray + changeableList.limitedCards.dropLast().filter { $0 != card } + [card]
            changeableList.limitedCards = newCards
        } else {
            let newCards = changeableList.limitedCards.filter { $0 != card } + [card]
            changeableList.limitedCards = newCards
        }
        self.viewModel.list = changeableList
    }
    
    func dragGestureDidChange(value: DragGesture.Value, card: Card, geometry: GeometryProxy) {
        guard viewModel.list.isFirst(ofLimited: card) else { return }
        let draggingMove = value.location.y - value.startLocation.y
        if draggingMove > 0 {
            self.viewModel.isDraggingDown = true
        } else {
            self.viewModel.isDraggingDown = false
        }
        draggingOffset = CGPoint(x: value.translation.width, y: value.translation.height)
        isDragging = true
        firstCardScale = newFirstCardScale(geometry: geometry)
    }
    
    func dragGestureDidEnd(value: DragGesture.Value, card: Card, geometry: GeometryProxy) {
        guard viewModel.list.isFirst(ofLimited: card) else { return }
        draggingOffset = .zero
            viewModel.list.limitedCards = cardsResortedAfterTranslation(draggedCard: card, yTranslation: value.translation.height, geometry: geometry)
            isDragging = false
    }
    
}

// MARK: Helper functions

extension ListCardsView {
    
    private func cardsResortedAfterTranslation(draggedCard card: Card, yTranslation: CGFloat, geometry: GeometryProxy) -> [Card] {
        let cardHeight = (geometry.size.width / CGFloat(Card.aspectRatio) - Self.padding)
        if abs(yTranslation + CGFloat(viewModel.list.limitedCards.count) * -Self.cardOffset) > cardHeight/3 {
            let numberLimitedCards = self.viewModel.list.limitedCards.filter{$0.isAddCard == false}.count
            if numberLimitedCards > 1 {
            let newLimitedCards = updateLimitedCardsAfterTransaction(draggedCard: card)
            updateAllCardsAfterTransaction(draggedCard: card)
                return newLimitedCards
            }
            return self.viewModel.list.limitedCards
        }
        
        return viewModel.list.limitedCards
    }
    
    private func updateLimitedCardsAfterTransaction(draggedCard card: Card) -> [Card] {
        var addCardArray = [Card]()
        var removableCardArray = self.viewModel.list.limitedCards
        var firstOfAllCardsArray = [Card]()
        if let addCard = self.viewModel.list.limitedCards.first, addCard.isAddCard == true {
            addCardArray.append(addCard)
            removableCardArray = Array(removableCardArray.dropFirst())
            if let firstOfAllCards = self.viewModel.list.cards.last {
                firstOfAllCardsArray = [firstOfAllCards]
            }
        } else {
            addCardArray = cardNew
        }
        return addCardArray + firstOfAllCardsArray + Array(removableCardArray.dropLast())
    }
    
    private func updateAllCardsAfterTransaction(draggedCard card: Card) {
        if card.isAddCard {
            self.viewModel.list.cards = self.viewModel.list.cards
            return
        }
        self.viewModel.list.cards = [card].filter{$0.isAddCard == false} + Array(self.viewModel.list.cards.dropLast())
    }
    
    private func newFirstCardScale(geometry: GeometryProxy) -> CGFloat {
        if draggingOffset.y > 0 {
            let newScale = 1 + draggingOffset.y / (1.5 * geometry.size.height)
            return min(Self.cardScaleWhenDragginDown, newScale)
        } else {
            let newScale = 1 + draggingOffset.y / (1.5 * geometry.size.height)
            return max(1 - CGFloat(viewModel.list.limitedCards.count) * Self.cardShrinkRatio, newScale)
        }
    }
    
    private func transitionDelay(card: Card) -> Double {
        guard shouldDelay else { return 0 }
        return Double(viewModel.list.index(ofLimited: card)) * Self.cardTransitionDelay
    }
    
    private func opacity(for card: Card) -> Double {
        let cardIndex = Double(viewModel.list.index(ofLimited: card))
        return 1 - cardIndex * Self.cardOpacity
    }
    
    private func offsetY(for card: Card) -> CGFloat {
        guard !viewModel.list.isFirst(ofLimited: card) else { return draggingOffset.y }
        let cardIndex = CGFloat(viewModel.list.index(ofLimited: card))
        let multiplier: CGFloat = card.isAddCard ? 1.2 : 1
        let offSet = (cardIndex * multiplier * Self.cardOffset)
        return offSet
    }
    
    private func scaleEffect(for card: Card) -> CGFloat {
        guard !(isDragging && viewModel.list.isFirst(ofLimited: card)) else { return firstCardScale }
        let cardIndex = CGFloat(viewModel.list.index(ofLimited: card))
        return 1 - cardIndex * Self.cardShrinkRatio
    }
    
    private func rotationAngle(for card: Card) -> Angle {
        guard !viewModel.list.isFirst(ofLimited: card) && !isDragging else { return .zero }
        if card.isAddCard { return Angle(degrees: Self.cardRotationAngle) }
        return Angle(degrees: Self.cardRotationAngle)
    }
}

extension AnyTransition {
    static var moveUpWardsWhileFadingIn: AnyTransition {
        return AnyTransition.move(edge: .bottom).combined(with: .opacity)
    }
    
    static var moveDownWardsWhileFadingIn: AnyTransition {
        return AnyTransition.move(edge: .top).combined(with: .opacity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListCardsView()
    }
}
