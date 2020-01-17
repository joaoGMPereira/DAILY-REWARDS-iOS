//
//  SUIJewSegmentedControl.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 09/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]

    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyTextPreferenceData: Equatable {
    let viewIndex: Int
    let rect: CGRect
}

struct SUIJewSegmentedControl : View {
    
    @Binding var selectedIndex: Int
    @Binding var rects: [CGRect]
    @Binding var titles: [String]

    var body: some View {
        ZStack(alignment: .topLeading) {
            ExDivider()
                .frame(width: rects[selectedIndex].size.width, height: 2)
                .offset(x: rects[selectedIndex].minX, y: rects[selectedIndex].maxY)
                .animation(.easeInOut(duration: 0.5))
            
            VStack {
                self.addTitles()
            
            }.onPreferenceChange(MyTextPreferenceKey.self) { preferences in
                    for p in preferences {
                        self.rects[p.viewIndex] = p.rect
                    }
            }
        }.coordinateSpace(name: "SUIJewSegmentedControl")
    }
    
    func totalSize() -> CGSize {
        var totalSize: CGSize = .zero
        for rect in rects {
            totalSize.width += rect.width
            totalSize.height = rect.height
        }
        return totalSize
    }
    
    func addTitles() -> some View {
        
        HStack(alignment: .center, spacing: 8, content: {
           ForEach(0..<titles.count) { index in
            return SegmentView(selectedIndex: self.$selectedIndex, label: self.titles[index], index: index, isSelected: self.segmentIsSelected(selectedIndex: self.selectedIndex, segmentIndex: index))
            }
        })
    }
    
    func segmentIsSelected(selectedIndex: Int, segmentIndex: Int) -> Binding<Bool> {
        return Binding(get: {
            return selectedIndex == segmentIndex
        }) { (value) in }
    }
}

struct SegmentView: View {
    @Binding var selectedIndex: Int
    let label: String
    let index: Int
    @Binding var isSelected: Bool
    var body: some View {
        Text(label)
            .padding(10)
            .foregroundColor(isSelected == true ? Color.init(.JEWDefault()) : Color.init(red: 220, green: 220, blue: 220))
            .background(MyPreferenceViewSetter(index: index)).onTapGesture {
                self.selectedIndex = self.index
        }
    }
}

struct MyPreferenceViewSetter: View {
    let index: Int
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: MyTextPreferenceKey.self,
                            value: [MyTextPreferenceData(viewIndex: self.index, rect: geometry.frame(in: .named("SUIJewSegmentedControl")))])
        }
    }
}


struct ExDivider: View {
    let color: Color = Color.init(.JEWDefault())
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
