//
//  SUIJewExpandableView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 16/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct JEWPreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue = CGSize.zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


struct JEWGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle()
                .foregroundColor(.clear)
                .preference(key: JEWPreferenceKey.self, value: geometry.size)
        }
    }
}


struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue = CGSize.zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct TextGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle()
                .foregroundColor(.clear)
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SUIJewExpandableView: View {
    @Binding var rects: [CGRect]
    @Binding var isOpened: Bool
    let viewHeightClosed: CGFloat = 65
    let viewHeightOpened: CGFloat = 150
    @State private var size: CGSize = .zero
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Color.init(.JEWBackground())
                ExpandableContentView(isOpen: self.$isOpened, parentSize: self.$size).onPreferenceChange(JEWPreferenceKey.self, perform: { self.size = $0 })
            }.background(JEWGeometry()).frame(width: geometry.size.width, height: self.isOpened ? self.viewHeightOpened : self.viewHeightClosed).edgesIgnoringSafeArea(.all)
            
        }
    }
}


struct ExpandableContentView: View {
    let padding: CGFloat = 16
    let widthImageOpened: CGFloat = 80
    let widthImageClosed: CGFloat = 40
    @Binding var isOpen: Bool
    @Binding var parentSize: CGSize
    @State private var size: CGSize = .zero
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                Color.init(.JEWBackground())
                Text("Tweets321312312")
                    .foregroundColor(.white)
                    .offset(x: self.textOffsetX(proxy: proxy), y: self.textOffsetY(proxy: proxy))
                    .background(TextGeometry())
                    .onPreferenceChange(SizePreferenceKey.self, perform: { self.size = $0 })
                    .padding(.horizontal, 10)
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .frame(height:self.isOpen ? self.widthImageOpened : self.widthImageClosed).clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3)).position(x: self.imageOffsetX(proxy: proxy), y: self.imageOffsetY(proxy: proxy))
            }
        }
    }
    func textOffsetX(proxy: GeometryProxy) -> CGFloat {
        return self.isOpen ? self.parentSize.width/2 : -((proxy.size.width/2) - (self.size.width/2) - padding)
    }
    
    func textOffsetY(proxy: GeometryProxy) -> CGFloat {
        return self.isOpen ? -proxy.size.height/2 : 0
    }
    
    func imageOffsetX(proxy: GeometryProxy) -> CGFloat {
        let imageWidth = self.isOpen ? self.widthImageOpened : self.widthImageClosed
        return  self.isOpen ? proxy.size.width/2 : proxy.size.width - imageWidth/2 - padding
    }
    
    func imageOffsetY(proxy: GeometryProxy) -> CGFloat {
        return proxy.size.height/2
    }
}

struct SUIJewExpandableView_Previews: PreviewProvider {
    @State static var rects = Array<CGRect>(repeating: CGRect(), count: 1)
    @State static var isOpened = true
    static var previews: some View {
        SUIJewExpandableView(rects: $rects, isOpened: $isOpened)
    }
}

