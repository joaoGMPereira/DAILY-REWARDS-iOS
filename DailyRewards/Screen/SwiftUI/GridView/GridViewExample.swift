//
//  GridViewExample.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 21/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI


struct ExampleTest : Codable, Identifiable {
    var id: Int
}


struct QExamplesConstants {
    static let showDesigner = true
    static let columnsMax = 8
    static let vSpacingMaxToGeometryRatio: CGFloat = 0.5 // 50%
    static let vPaddingMaxToGeometryRatio: CGFloat = 0.3 // 30%
    static let hPaddingMaxToGeometryRatio: CGFloat = 0.3 // 30%
}

struct GridViewExample: View {
    
    @State var columns: CGFloat = 5.0
    @State var vSpacing: CGFloat = 8.0
    @State var hSpacing: CGFloat = 8.0
    @State var vPadding: CGFloat = 8.0
    @State var vStackPadding: CGFloat = 8.0
    @State var hPadding: CGFloat = 8.0
    
    let npsValues: [ExampleTest] = [ExampleTest(id: 1),ExampleTest(id: 2),ExampleTest(id: 3),ExampleTest(id: 4),ExampleTest(id: 5),ExampleTest(id: 6),ExampleTest(id: 7),ExampleTest(id: 8),ExampleTest(id: 9),ExampleTest(id: 10)]
    @State var transition = AnyTransition.moveRightWardsWhileFadingIn
    @State var shouldDelay = true
    @State var alignmentCenter = true
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.backgroundGradient
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if (QExamplesConstants.showDesigner) { self.designerView(geometry) }
                    self.gridView(geometry)
                }
            }
        }
    }
    
    private func gridView(_ geometry: GeometryProxy) -> some View {
        GridView<[ExampleTest], GridViewExampleCell>(data: npsValues,
                                     columns: Int(self.columns),
                                     columnsInLandscape: Int(self.columns),
                                     vSpacing: min(self.vSpacing, self.vSpacingMax(geometry)),
                                     hSpacing: max(min(self.hSpacing, self.hSpacingMax(geometry)), 0.0),
                                     vPadding: min(self.vPadding, self.vPaddingMax(geometry)),
                                     vStackPadding: min(self.vStackPadding, self.vPaddingMax(geometry)),
                                     hPadding: max(min(self.hPadding, self.hPaddingMax(geometry)), 0.0),
                                     shouldDelay: shouldDelay,
                                     transition: $transition, alignmentCenter: $alignmentCenter) {
                                        GridViewExampleCell(value: $0)
        }
    }
    
    private func designerView(_ geometry: GeometryProxy) -> some View {
        return
            VStack {
                layoutSlider(name: "Columns:",
                             layoutParam: self.$columns,
                             minValue: 1.0,
                             maxValue: CGFloat(QExamplesConstants.columnsMax))
                layoutSlider(name: "vSpacing:",
                             layoutParam: self.$vSpacing,
                             maxValue: self.vSpacingMax(geometry))
                layoutSlider(name: "hSpacing:",
                             layoutParam: self.$hSpacing,
                             maxValue: self.hSpacingMax(geometry))
                layoutSlider(name: "vPadding:",
                             layoutParam: self.$vPadding,
                             maxValue: self.vPaddingMax(geometry))
                layoutSlider(name: "vStackPadding:",
                             layoutParam: self.$vStackPadding,
                             maxValue: self.vPaddingMax(geometry))
                layoutSlider(name: "hPadding:",
                             layoutParam: self.$hPadding,
                             maxValue: self.hPaddingMax(geometry))
            }
            .padding([.bottom], 10)
    }
    
    private func layoutSlider(name: String,
                              layoutParam: Binding<CGFloat>,
                              minValue: CGFloat = 0.0,
                              maxValue: CGFloat) -> some View {
        HStack {
            Text(name)
            Text("\(Int(min(layoutParam.wrappedValue, maxValue)))")
            Slider(value: layoutParam, in: minValue...maxValue, step: 1.0)
        }
        .font(.headline).foregroundColor(.white)
        .padding([.horizontal], 10)
        .padding([.bottom], -10)
    }
    
    private func vSpacingMax(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * QExamplesConstants.vSpacingMaxToGeometryRatio
    }
    
    private func hSpacingMax(_ geometry: GeometryProxy) -> CGFloat {
        return max(geometry.size.width/self.columns - 2 * hPadding, 1.0)
    }
    
    private func vPaddingMax(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * QExamplesConstants.vPaddingMaxToGeometryRatio
    }
    
    private func hPaddingMax(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width * QExamplesConstants.hPaddingMaxToGeometryRatio
    }
    
    private var backgroundGradient: LinearGradient {
        let gradient = Gradient(colors: [
            Color(red: 192/255.0, green: 192/255.0, blue: 192/255.0),
            Color(red: 50/255.0, green: 50/255.0, blue: 50/255.0)
        ])
        return LinearGradient(gradient: gradient,
                              startPoint: .top,
                              endPoint: .bottom)
    }
}

struct GridViewExampleCell: View {
    var value: ExampleTest
    @State var isSelected: Bool = false
    var body: some View {
        Circle()
            .overlay(
                Circle().stroke(isSelected ? Color.clear: Color.red,lineWidth: 3).overlay(Text("\(value.id)").foregroundColor(isSelected ? Color.white: Color.red))
                
        ).foregroundColor(isSelected ? Color.red: Color.clear).frame(width: 40, height: 40).onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                self.isSelected.toggle()
            }
        }
        
    }
}

#if DEBUG
struct GridViewExample_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(["iPhone SE", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            GridViewExample()
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
#endif
