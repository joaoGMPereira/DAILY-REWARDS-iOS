//
//  SUIJewExpandableView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 16/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

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
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var image: UIImage
    @State private var parentSize: CGSize = .zero
    @State private var size: CGSize = .zero
    let padding: CGFloat = 16
    let heightImageOpened: CGFloat = 80
    let heightImageClosed: CGFloat = 40
    let viewHeightClosed: CGFloat = 65
    let viewHeightOpened: CGFloat = 150

    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Color.init(.JEWBackground())
                GeometryReader { proxy in
                    ZStack {
                        Color.init(.JEWBackground())
                        Text(self.title)
                            .foregroundColor(Color.init(red: 220, green: 220, blue: 220))
                            .offset(x: self.textOffsetX(proxy: proxy), y: self.textOffsetY(proxy: proxy))
                            .background(TextGeometry())
                            .onPreferenceChange(SizePreferenceKey.self, perform: { self.size = $0 })
                            .padding(.horizontal, 10)
                        Image(uiImage: self.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .frame(height:self.imageHeight()).clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3)).position(x: self.imageOffsetX(proxy: proxy), y: self.imageOffsetY(proxy: proxy))
                    }
                }
            }.frame(width: geometry.size.width, height: self.isOpened ? self.viewHeightOpened : self.viewHeightClosed).edgesIgnoringSafeArea(.all)
            
        }
    }
    
    func imageHeight() -> CGFloat {
        if isPresented {
            return 120
        }
        return self.isOpened ? self.heightImageOpened : self.heightImageClosed
    }
    func textOffsetX(proxy: GeometryProxy) -> CGFloat {
        if isOpened {
            return .zero
        }
            return -((proxy.size.width/2) - (self.size.width/2) - padding)
       }
       
       func textOffsetY(proxy: GeometryProxy) -> CGFloat {
           return self.isOpened ? -proxy.size.height/2 : 0
       }
       
       func imageOffsetX(proxy: GeometryProxy) -> CGFloat {
           let imageWidth = self.isOpened ? self.heightImageOpened : self.heightImageClosed
        if isPresented {
            return proxy.size.width/2 + 40
        }
           return  self.isOpened ? proxy.size.width/2 : proxy.size.width - imageWidth/2 - padding
       }
       
       func imageOffsetY(proxy: GeometryProxy) -> CGFloat {
        if isPresented {
            return proxy.size.width/2 - 40
        }
           return proxy.size.height/2
       }
}

struct SUIJewExpandableView_Previews: PreviewProvider {
    @State static var rects = Array<CGRect>(repeating: CGRect(), count: 1)
    @State static var isOpened = true
    @State static var isPresented = false
    @State static var title = "Mock Name"
    @State static var image = UIImage()
    static var previews: some View {
        SUIJewExpandableView(rects: $rects, isOpened: $isOpened, isPresented: $isPresented, title: $title, image: $image)
    }
}

