//
//  CardView.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 10/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    var card: Card
    
    var body: some View {
        GeometryReader { (geometry) in
            VStack(alignment: .center, spacing: 0) {
                Group {
                    Spacer()
                    HStack(alignment: .center) {
                        self.topLeftImage(for: geometry)
                        Spacer()
                        self.topRightImage(for: geometry).padding()
                        
                    }.padding(.horizontal)
                    VStack(spacing: 5) {
                        self.title
                        self.description
                    }.padding(.bottom, geometry.size.height / 100).shadow(color: self.card.type.shadowColor, radius: 5, x: 0, y: 0)
                    ZStack(alignment: .center) {
                        self.status
                    }.padding(.horizontal).shadow(color: self.card.type.shadowColor, radius: 5, x: 0, y: 0)
                    Spacer()
                }
            }.frame(width: geometry.size.width,
                    height: geometry.size.width / CGFloat(Card.aspectRatio))
                .background(Color.init(.JEWDefault()))
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
}

// MARK: Subviews

extension CardView {
    
    func topLeftImage(for geometry: GeometryProxy) -> some View {
        return Image(card.leftImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.clear)
            .foregroundColor(.white)
            .frame(height: UIScreen.main.bounds.height / 12).clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(card.type.firstColor, lineWidth: 3)).offset(x: 0, y: card.isAddCard ? -30 : 0)
    }
    
    func topRightImage(for geometry: GeometryProxy) -> some View {
        guard card.isAddCard else {
            if card.isIndividual {
                return AnyView(topRightIndividualImage(for: geometry))
            }
            return AnyView(topRightGroupImage(for: geometry))
        }
        return AnyView(EmptyView())
    }
    
    func topRightGroupImage(for geometry: GeometryProxy) -> some View {
        return ZStack {
            Image(card.rightImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.clear)
                .foregroundColor(card.type.firstColor)
                .frame(height: UIScreen.main.bounds.height / 24).offset(x: -10, y: 0)
            Image(card.rightImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.clear)
                .foregroundColor(card.type.firstColor)
                .frame(height: UIScreen.main.bounds.height / 24).offset(x: 10, y: 0)
            Image(card.rightImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.clear)
            .foregroundColor(card.type.firstColor)
            .frame(height: UIScreen.main.bounds.height / 24).offset(x: 0, y: -2)
        }.opacity(0.8)
    }
    func topRightIndividualImage(for geometry: GeometryProxy) -> some View {
        return ZStack {
            Image(card.rightImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.clear)
            .foregroundColor(card.type.firstColor)
            .frame(height: UIScreen.main.bounds.height / 24)
        }.opacity(0.8)
    }
    
    var title: some View {
        Text(card.title)
            .foregroundColor(card.type.highlightedColor)
            .font(.system(size: 23, weight: .medium))
    }
    
    var description: some View {
        VStack(alignment: .center, spacing: 3) {
            Group {
                Text(card.descripton).font(.system(size: 15))
            }
            .foregroundColor(card.type.highlightedColor)
        }
    }
    
    var status: some View {
        Text(card.type.statusText)
            .foregroundColor(card.type.highlightedColor)
            .minimumScaleFactor(2)
            .font(.system(size: 16))
            .shadow(radius: 3)
            .padding(.horizontal)
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            CardView(card: cards[1])
                .padding(32)
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
