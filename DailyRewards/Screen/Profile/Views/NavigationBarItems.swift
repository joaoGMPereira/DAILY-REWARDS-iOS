//
//  NavigationBarItems.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 22/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI


struct NavigationLeftItem: View {
    @Binding var isPresented: Bool
    var body: some View {
        Button(action: {
            self.isPresented = false
        }, label: { Image(systemName: "xmark").scaleEffect(1.5) })
    }
}

class NavigationItemCallback: ObservableObject {
    typealias DidTap = (() -> ())
    @Published var didTap: DidTap?
}


struct NavigationImageItem: View {
    let router: DailyRewardsRouterProtocol = DailyRewardsRouter()
    @ObservedObject var callback = NavigationItemCallback()
    @Binding var image: Image
    var body: some View {
        Button(action: {
            self.callback.didTap?()
        }, label: { image.scaleEffect(1.5) })
    }
}
