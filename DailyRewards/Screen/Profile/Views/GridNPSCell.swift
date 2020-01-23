//
//  GridNPSCell.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 21/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct NPS : Codable, Identifiable {
    var id: Int
}

class NPSCellCallback: ObservableObject {
    typealias DidTapCell = ((Int, Bool) -> ())
    @Published var didTap: DidTapCell?
}

struct GridNPSCell: View {
    var value: NPS
    @ObservedObject var cellCallback = NPSCellCallback()
    @Binding var isSelected: Bool
    let color = Color(.JEWDefault())
    var body: some View {
        Circle()
            .overlay(
                Circle().stroke(isSelected ? Color.clear: color,lineWidth: 3).overlay(Text("\(value.id)").foregroundColor(isSelected ? Color.white: color))
                
        ).foregroundColor(isSelected ? color: Color.clear).frame(width: 35, height: 35).onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                self.isSelected.toggle()
                self.cellCallback.didTap?(self.value.id, self.isSelected)
            }
        }
        
    }
}

struct GridNPSCell_Previews: PreviewProvider {
    @State static var isSelected = false
    static var previews: some View {
        GridNPSCell(value: NPS(id: 0), isSelected: $isSelected)
    }
}
