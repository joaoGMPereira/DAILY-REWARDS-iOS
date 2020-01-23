//
//  NewChallengeView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 08/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct NewListChallengeView: View {
    @State var selectedIndex: Int = 0
    @State var titles = ["Todos", "Individuais", "Em Grupo"]
    @State var nameTitle = ""
    @State var image = UIImage()
    @State var rects = Array<CGRect>(repeating: CGRect(), count: 4)
    @State var rectsExpandable = Array<CGRect>(repeating: CGRect(), count: 1)
    @State var expandableIsOpened: Bool = false
    @State var showProfile: Bool = false
    @State var controller: NewListChallengeViewController?
    var cardView = ListCardsView()
    var router = DailyRewardsRouter()
    
    var body: some View {
                GeometryReader.init { geometry in
                    ZStack(alignment: .top, content: {
                        Color(.JEWBackground())
                            .edgesIgnoringSafeArea(.all)
                        VStack(alignment: .center, spacing: 8) {
                            SUIJewExpandableView(rects: self.$rectsExpandable, isOpened:  self.$expandableIsOpened, isPresented: self.$showProfile, title: self.$nameTitle, image: self.$image).frame(width: geometry.size.width, height: self.expandableIsOpened ? 150 : 65).padding(.top, 20).animation(.linear).onTapGesture {
                                withAnimation{
                                    self.showProfile.toggle()
                                }
                            }
                            VStack(alignment: .center, spacing: 96) {
                                SUIJewSegmentedControl(selectedIndex: self.$selectedIndex, rects: self.$rects, titles: self.$titles)
                                VStack(alignment: .center) {
                                    self.setCardsView(geometry: geometry)
                                }
                            }
            
                        }
                    })
                }.onAppear {
                    self.controller = NewListChallengeViewController(withDelegate: self)
                }
                .sheet(isPresented: self.$showProfile) {
                    NewProfileView(isPresented: self.$showProfile)
                }
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.updateHeader(value: value)
                        })
                )
    }
    
    func updateHeader(value: DragGesture.Value) {
        let dragHeight = value.location.y - value.startLocation.y
        
        if abs(dragHeight) > 50 {
            withAnimation {
                if dragHeight < 0 {
                    self.expandableIsOpened = false
                } else {
                    self.expandableIsOpened = true
                }
                self.cardView.viewModel.forceUpdateLayout = self.expandableIsOpened ? 0.01 : 0
            }
        }
    }
    
    func setCardsView(geometry: GeometryProxy) -> some View {
        self.cardView.viewModel.list = getCardList()
        self.cardView.viewModel.isDraggingDown = true
        return self.cardView.frame(width: geometry.size.width, height: geometry.size.width / CGFloat(Card.aspectRatio), alignment: .center)
    }
    
    func getCardList() -> ListCard {
        if selectedIndex == 0 {
            return ListCard(cards: cards, showLimit: 4)
        } else if selectedIndex == 1 {
            return ListCard(cards: cards.filter{$0.isIndividual == true}, showLimit: 4)
        }
        return ListCard(cards: cards.filter{$0.isIndividual == false}, showLimit: 4)
    }
}

extension NewListChallengeView: NewListChallengeViewControllerDelegate {
    func displayProfile(image: UIImage) {
        self.image = image
    }
    
    func displayProfile(name: String) {
        nameTitle = name
    }
    
    func displayProfile(error: String) {
        
    }
    
    func displayNew() {
        
    }
    
    func displayDetail(challenge: Challenge) {
        
    }
    
    
}

struct NewListChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            NewListChallengeView()
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
