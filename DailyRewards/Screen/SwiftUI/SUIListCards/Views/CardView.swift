//
//  CardView.swift
//  BankCards
//
//  Created by Fernando Moya de Rivas on 10/11/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    @ObservedObject var card: Card
    @State var cornerRadius: CGFloat = 10
    var body: some View {
        GeometryReader { (geometry) in
            VStack(alignment: .center, spacing: 0) {
                Group {
                    Spacer()
                    HStack(alignment: .center) {
                        self.topLeftImage(for: geometry, isLoading: self.card.isLoading)
                        Spacer()
                        self.topRightImageWithLoading(for: geometry, isLoading: self.card.isLoading).padding()
                        
                    }.padding(.horizontal)
                    Spacer()
                    VStack(spacing: 8) {
                        self.title
                        self.description
                        self.status
                    }.padding(.bottom, geometry.size.height / 100).shadow(color: self.card.type.shadowColor, radius: 5, x: 0, y: 0)

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
    
    func topLeftImage(for geometry: GeometryProxy, isLoading: ViewState) -> some View {
        SUIJewGenericView(viewState: isLoading) {
            Image(self.card.leftImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.clear)
            .foregroundColor(.white)
            .frame(height: UIScreen.main.bounds.height / 14).clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                .overlay(RoundedRectangle(cornerRadius: self.cornerRadius).stroke(self.card.type.firstColor, lineWidth: 3)).offset(x: 0, y: self.card.isAddCard ? -10 : 0)
        }.cornerRadius(10)
    }
    
    func topRightImageWithLoading(for geometry: GeometryProxy, isLoading: ViewState) -> some View {
        SUIJewGenericView(viewState: isLoading) {
            self.topRightImage(for: geometry)
        }.cornerRadius(10)
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
        SUIJewGenericView(viewState: self.card.isLoading) {
            Text(self.card.title)
                .foregroundColor(self.card.type.highlightedColor)
            .font(.system(size: 23, weight: .medium))
        }.cornerRadius(10)
    }
    
    var description: some View {
        SUIJewGenericView(viewState: self.card.isLoading) {
            VStack(alignment: .center, spacing: 3) {
                Group {
                    Text(self.card._description).font(.system(size: 15))
                }.foregroundColor(self.card.type.highlightedColor)
            }
        }.cornerRadius(10)
    }
    
    var status: some View {
        SUIJewGenericView(viewState: self.card.isLoading) {
            Text(self.card.type.statusText)
                .foregroundColor(self.card.type.highlightedColor)
                .minimumScaleFactor(2)
                .font(.system(size: 14))
                .shadow(radius: 3)
        }.cornerRadius(10)
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            CardView(card: cards[0])
                .padding(32)
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
