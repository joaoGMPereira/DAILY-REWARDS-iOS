//
//  SUICustomizedToggle.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 21/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct SUICustomizedToggleStyle: ToggleStyle {
    typealias HasSelected = ((Bool) -> Void)
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    var isSelected: HasSelected

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label).font(.headline)
            Button(action: {
                configuration.isOn.toggle()
                self.isSelected(configuration.isOn)
            } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
        .font(.title)
        .padding(.horizontal)
    }
}
