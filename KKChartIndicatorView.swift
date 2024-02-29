//
//  KKChartIndicatorView.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import SwiftUI
import Charts


struct KKChartIndicatorView: View {
  
  @State var model: KKChartIndicator
  @Binding var selectedElement: Int?
  
  init(model: KKChartIndicator,
       selectedElement: Binding<Int?>) {
    self._model = State(wrappedValue: model)
    self._selectedElement = selectedElement
  }
  
  var body: some View {
    VStack {
      if let chartView = model.chartView {
        AnyView(chartView)
        .chartOverlay { chartProxy in
          GeometryReader { geo in
            ZStack {
              Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .gesture(gesturePressDetect(proxy: chartProxy, geometry: geo))
                .overlay {
                  if let selectedElement, model.getCount() > selectedElement {
                    
                    let count =  CGFloat(model.getCount())
                    
                    let (relativeXPosition,relativeYPosition) = getRelativePosition(proxy: chartProxy, geo: geo)
                    let (chartWidth,chartHeight) = getChartFrame(proxy: chartProxy, geo: geo)
                    
                    
                    let resolutionX =  chartWidth / (count - 1)
                    let resolutionY = chartHeight / resulutionY()
                    
                    let offsetx = resolutionX * CGFloat(selectedElement) + relativeXPosition
                    
                    VStack(spacing: 0) {
                      
                      Spacer()
                      
                      HStack(spacing: 0 ) {
                        Rectangle()
                          .frame(width: 2, height: ((model.getValueByIndex(by: selectedElement) - (model.getMin())) * resolutionY)  )
                          .overlay{
                            VStack(spacing: 0) {
                              Circle()
                                .frame(width: 5, height: 5, alignment: .center)
                                .offset(y: -2)
                              
                              Spacer()
                            }
                          }
                          .offset(x: offsetx, y: -4)
                          .padding(.bottom, relativeYPosition / 2)
                        
                        
                        Spacer()
                      }
                    }
                    .foregroundStyle(model.config.colorIndicator)
                  }
                }
            }
          }
        }
      } else {
        Text("Brak danych")
      }
      
    }
    .animation(.default, value: selectedElement)
    .task {
      self.model.render()
    }
    //      .tileBackground_v2
  }
  
  fileprivate func getChartFrame(proxy: ChartProxy, geo: GeometryProxy) -> (Double, Double) {
    let chartWidth  = geo[proxy.plotAreaFrame].width
    let chartHeight = geo[proxy.plotAreaFrame].height
    return (chartWidth, chartHeight)
  }
  
  fileprivate func getRelativePosition(proxy: ChartProxy, geo: GeometryProxy) -> (Double, Double) {
    let x  = geo[proxy.plotAreaFrame].origin.x
    let y = geo[proxy.plotAreaFrame].origin.y
    return (x, y)
  }
  
  fileprivate func resulutionY() -> Double {
    let resY: Double = Double(model.getMax() - model.getMin())
    return resY
  }
  
  fileprivate func getMinMaxValue(values: [Double]) -> (Double?,Double?) {
    let min = (values.min() ?? 0)
    let max = (values.max() ?? 10)
    
    let rangePrecentStep = (max - min) * 0.1
    
    return (min - rangePrecentStep, max + rangePrecentStep)
  }
  
  fileprivate func find(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Int? {
    let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
    let resolution = proxy.plotAreaSize.width / CGFloat(model.getCount())
    
    let indexDouble = (relativeXPosition / resolution)
    let index = Int(indexDouble.rounded())
    
    
//    print(location.x)
    
    if (model.getCount() - 1) >= index && index >= 0 {
      return index
    } else {
      return nil
    }
  }
  
  fileprivate func gestureLongPressDetect(proxy: ChartProxy, geometry: GeometryProxy) -> some Gesture {
    TapGesture()
      .exclusively(
        before: DragGesture(minimumDistance: 0)
          .onChanged { value in
            selectedElement = find(location: value.location,
                                   proxy: proxy,
                                   geometry: geometry)
          }
          .onEnded { _ in
            selectedElement = nil
          }
      )
  }
  
  fileprivate func gesturePressDetect(proxy: ChartProxy, geometry: GeometryProxy) -> some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
        selectedElement = find(location: value.location,
                               proxy: proxy,
                               geometry: geometry)
      }
      .onEnded { _ in
        selectedElement = nil
      }
  }
}


fileprivate struct MyView: View {
  @State var index: Int?
  var body: some View {
    VStack {
      KKChartIndicatorView(model: .mock(120), selectedElement: $index)
      .frame(height: 150)
      .padding()
      
      KKChartIndicatorView(model: .mock(120,colorChart: .red,colorIdicator: .green), selectedElement: $index)
      .frame(height: 150)
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
//    .background(Color.gray)
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
