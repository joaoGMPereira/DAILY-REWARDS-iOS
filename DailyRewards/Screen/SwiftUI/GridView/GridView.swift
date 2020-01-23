//
//  SwiftUIViewTest.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 20/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//
import SwiftUI


/// A container that presents rows of data arranged in multiple columns.
public struct GridView<Data, Content>: View
  where Data : RandomAccessCollection, Content : View, Data.Element : Identifiable {
  private struct QGridIndex : Identifiable { var id: Int }
  
    // MARK: - INITIALIZERS
     
     /// Creates a QGrid that computes its cells on demand from an underlying
     /// collection of identified data.
     ///
     /// - Parameters:
     ///     - data: A collection of identified data.
     ///     - columns: Target number of columns for this grid, in Portrait device orientation
     ///     - columnsInLandscape: Target number of columns for this grid, in Landscape device orientation; If not provided, `columns` value will be used.
     ///     - vSpacing: Vertical spacing: The distance between each row in grid. If not provided, the default value will be used.
     ///     - hSpacing: Horizontal spacing: The distance between each cell in grid's row. If not provided, the default value will be used.
     ///     - vPadding: Vertical padding: The distance between top/bottom edge of the grid and the parent view. If not provided, the default value will be used.
    ///   - vStackPadding: Vertical Stack padding: The distance between top/bottom edge of the grid and the parent view. If not provided, the default value will be used.
    ///     - hPadding: Horizontal padding: The distance between leading/trailing edge of the grid and the parent view. If not provided, the default value will be used.
    ///     - content: A closure returning the content of the individual cell
    ///   - shouldDelay: Show Cells with animation
    ///   - transition: Show Cells with transition
    ///   - alignmentCenter: Show Cells in Center
    
    
  // MARK: - STORED PROPERTIES
    let data: [Data.Element]
    let columns: Int
    let columnsInLandscape: Int
    let vSpacing: CGFloat
    let hSpacing: CGFloat
    let vPadding: CGFloat
    let vStackPadding: CGFloat
    let hPadding: CGFloat
    @State private var isShowing: Bool = false
    @State var shouldDelay: Bool = true
    @Binding var transition: AnyTransition
    @Binding var alignmentCenter: Bool
    let content: (Data.Element) -> Content
  
  // MARK: - COMPUTED PROPERTIES
  
  private var rows: Int {
    data.count / self.cols
  }
  
  private var cols: Int {
    return UIDevice.current.orientation.isLandscape ? columnsInLandscape : columns
  }
  /// Declares the content and behavior of this view.
  public var body : some View {
    GeometryReader { geometry in
      ScrollView(showsIndicators: false) {
        VStack(spacing: self.vSpacing) {
          ForEach((0..<self.rows).map { QGridIndex(id: $0) }) { row in
            self.rowAtIndex(row.id * self.cols,
                            geometry: geometry)
          }
          // Handle last row
          if (self.data.count % self.cols > 0) {
            self.rowAtIndex(self.cols * self.rows,
                            geometry: geometry,
                            isLastRow: true)
          }
            Rectangle().fill(Color.clear)
        }.onAppear{
            self.shouldDelay = false
        }.padding(.top, self.vStackPadding)
      }.onAppear{
          self.isShowing.toggle()
      }
      .padding(.horizontal, self.hPadding)
      .padding(.vertical, self.vPadding)
    }
  }
  
  // MARK: - `BODY BUILDER` 💪 FUNCTIONS
  
  private func rowAtIndex(_ index: Int,
                          geometry: GeometryProxy,
                          isLastRow: Bool = false) -> some View {
    HStack(spacing: self.hSpacing) {
      ForEach((0..<(isLastRow ? data.count % cols : cols))
      .map { QGridIndex(id: $0) }) { column in
        if self.isShowing {
        self.content(self.data[index + column.id])
            .frame(width: self.contentWidthFor(geometry)).transition(self.transition).animation(Animation.easeInOut.delay(self.shouldDelay ? Double(index + column.id) * 0.05 : 0))
        }
      }
        if !alignmentCenter {
            if isLastRow { Spacer() }
        }
    }
  }
    
  // MARK: - HELPER FUNCTIONS
  
  private func contentWidthFor(_ geometry: GeometryProxy) -> CGFloat {
    let hSpacings = hSpacing * (CGFloat(self.cols) - 1)
    let width = geometry.size.width - hSpacings - hPadding * 2
    return width / CGFloat(self.cols)
  }
}
