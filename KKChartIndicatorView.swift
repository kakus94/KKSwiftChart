//
//  KKChartIndicatorView.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import SwiftUI
import Charts

extension KKChartIndicatorView: KKChartDelegate {
  func setSelectedElement(result: [KKChartPositionIndicator?]?) {
    guard let result else { 
      posX = nil
      return
    }
    self.selectedDate = result
    posX = result.compactMap{ $0?.posX }.reduce(0, +) / 2
    
    print("X -> \(result.compactMap({ $0?.posX ?? 0})) Y -> \(result.compactMap({ $0?.posY ?? 0}))")
  }
  
  func getSeries() -> Dictionary<String, Color> {
    model.seria
  }
  
  func getValues() -> [KKPointChart] {
    model.values
  }
  
}


public struct KKChartIndicatorView: View {
  
  @State var model: KKChartIndicator
  @Binding var selectedDate: [KKChartPositionIndicator?]
  
  @State private var posX: CGFloat? = nil
  
  public init(model: KKChartIndicator,
       selectedElement: Binding<[KKChartPositionIndicator?]>) {
    self._model = State(wrappedValue: model)
    self._selectedDate = selectedElement
  }
  
  public var body: some View {
    VStack {
      if let chartView = model.chartView {
        AnyView(chartView)
          .chartPlotStyle { plotContent in
            plotContent
              .clipShape(Rectangle())
              .overlay(content: overlay)
          }
      } else {
        Text("Brak danych")
      }
      
    }
    .animation(.default, value: posX)
    .task {
      model.delegate = self
      model.setDomainX()
      model.setDomainY(margin: 0.1)
      model.render()
    }
  }
  
  func overlay() -> some View {
    GeometryReader { geo in
      ZStack {
        Rectangle()
          .fill(.clear)
          .contentShape(Rectangle())
          .gesture(model.gesturePressDetect(geometry: geo))
          .overlay {
            if let posX {
              HStack(spacing: 0 ) {
                Rectangle()
                  .frame(width: 2)
                  .frame(maxHeight: .infinity)
                  .overlay{
                    VStack(spacing: 0) {
                      Circle()
                        .frame(width: 5, height: 5, alignment: .center)
                        .offset(y: -2)
                        
                      
                      Spacer()
                    }
                  }
                  .offset(x: posX, y: -4)
//                  .padding(.bottom, ((posYs!.first ?? 0)!) / 2)
                
                
                Spacer()
              }
            }
          }
      }
    }
  }

}


fileprivate struct MyView: View {
  @State var index: [KKChartPositionIndicator?] = []
  var body: some View {
    VStack {
      KKChartIndicatorView(model: .mock(10), selectedElement: $index)
      .frame(height: 200)
      .padding()
      
      KKChartIndicatorView(model: .mock(10,colorChart: .red,colorIdicator: .green), selectedElement: $index)
      .frame(height: 200)
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  MyView()
}


extension [Double] {
  
  func generateValue(format: String, count: Int) -> [Double] {
    let min = self.min()!
    let max = self.max()!
    let range = max - min
    let step = range / Double(count)
    
    var result: [Double] = .init()
    
    for i in 0...count {
      result.append(min + (step * Double(i)))
    }
    
    return result
  }
  
}


fileprivate func generateMockData(_ count: Int) -> [(Date, Double)] {
  var result: [(Date, Double)] = .init()
  
  let date: Date = .now
  
  for i in 0...count {
    result.append(( date.addingTimeInterval(TimeInterval(3600 * i)), Double.random(in: 10...35) ))
  }
  
  return result
}


