//
//  KKZoomingChartView.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import SwiftUI
import Charts

struct KKChartZoomingView: View {
  
  @State var model: KKChartZooming
  
  @State private var tapStart: CGPoint = .zero
  @State private var transition: CGSize = .zero
  @State private var revers: Bool = false
  @State private var show: Bool = false
  
  var body: some View {
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
    .task {
      model.setDomainX()
      model.setDomainY(margin: 0.1)
      model.render()
    }
  }
}


extension KKChartZoomingView {
    
  func overlay() -> some View {
    GeometryReader { geo in
      ZStack {
        Rectangle()
          .fill(.clear)
          .contentShape(Rectangle())
          .gesture(gesturePressDetect(geometry: geo))
          .overlay {
            if show {
              Rectangle()
                .foregroundStyle(revers ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: abs(transition.width), height: abs(transition.height))
                .position(calculatePosition())
            }
          }
      }
    }
  }
  
  fileprivate func calculatePosition() -> CGPoint {
    if revers {
      return .init(x: tapStart.x + (transition.width / 2),
                   y: tapStart.y + (transition.height / 2))
    } else {
      return .init(x: tapStart.x + (transition.width / 2),
                   y: tapStart.y + (transition.height / 2))
    }
    
  }
  
  fileprivate func gesturePressDetect(geometry: GeometryProxy) -> some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
        self.tapStart = value.startLocation
        self.transition = value.translation
        self.revers = value.translation.width < 0
        self.show = true
        
      }
      .onEnded { _ in
        calculate(geometry: geometry)
        self.show = false
      }
  }
    
  fileprivate func calculate(geometry: GeometryProxy) {
    
    let (newMax,newMin) = getNewMaxMinValue(geometry: geometry)
    
    if let newMax, let newMin,
       let startDate = find(location: tapStart, geometry: geometry),
       let endDate   = find(location: .init(x: tapStart.x + transition.width, y: tapStart.y),
                            geometry: geometry) {
      
      if !revers {
        Task {
          await model.reRender(startDate, endDate, newMax, newMin)
        }
      } else {
        let rangeDate = startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970
        let halfRange = rangeDate
        
        let startDate2 = model.domainX.lowerBound.timeIntervalSince1970 - halfRange
        let endDate2 = model.domainX.upperBound.timeIntervalSince1970 + halfRange
        
        Task {
          await model.reRender(Date(timeIntervalSince1970: startDate2), Date(timeIntervalSince1970: endDate2), newMax, newMin)
        }
        
      }
    }
  }
    
  fileprivate func find(location: CGPoint, geometry: GeometryProxy) -> Date? {
    
    let domain = model.domainX
    let range = domain.upperBound.timeIntervalSince1970 - domain.lowerBound.timeIntervalSince1970
    
    let relativeXPosition = location.x
    let resolution = geometry.size.width / range
    
    let dateAdded = (relativeXPosition / resolution)
    
    let dataResult = dateAdded + domain.lowerBound.timeIntervalSince1970
    let dataSelected = Date(timeIntervalSince1970: dataResult)
    
    return dataSelected
    
  }
  
  fileprivate func getNewMaxMinValue(geometry: GeometryProxy) -> (CGFloat?, CGFloat?) {
    
    let min = model.getMin()
    let max = model.getMax()
    let resulutonY = max - min
    
    let tap = tapStart.y
    let tap2 = tap + transition.height
    
    print("\nmin:\(min) max:\(max)")
    
    let height = geometry.size.height
    let resolution = height / CGFloat(resulutonY)
    
    if !revers {
      //Normal
      let value1 = ((height - tap)  / resolution)
      let value2 = ((height - tap2) / resolution)
      
      let result = [value1 ,value2]
      return (result.max()! + min, result.min()! + min)
      
    } else {
      //Reverse
      let position = [tap,tap2]
      let value = (position.max()! - position.min()!) / resolution
      
      let value1 = max + (value / 2 )
      let value2 = min - (value / 2)
      
      let result = [value1 ,value2]
      return (result.max()!, result.min()! )
      
    }
    
  }
  
}


#Preview {
  KKChartZoomingView(model: KKChartZoomingView.mock(100, colorChart: .green))
    .frame(height: 350)
    .padding(.horizontal)
}


//MARK: Mock
extension KKChartZoomingView {
  static func mock(_ count: Int = 30, colorChart: Color = .blue, colorIdicator: Color = .blue) -> KKChartZooming {
    
    var model = KKChartZooming(includeFillChart: false, seria: ["Seria1": .blue, "Seria2": .purple])
    var points: [KKPointChart] = .init()
    let date: Date = .now
    
    let config = KKChartConfig(
      colorIndicator: colorIdicator,
      colorLineChart: colorChart,
      chartStyle: .init(colors: [colorChart.opacity(0.5), .clear],
                        startPoint: .top,
                        endPoint: .bottom))
    
    for i in 0...count {
      points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                          y: Double.random(in: 10...35),
                          seria: "Seria1", color: model.seria[0].value))
    }
    
    for i in 0...count {
      points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                          y: Double.random(in: 10...35),
                          seria: "Seria2", color: model.seria[1].value))
    }
    
    model.setValues(points)
    model.setConfig(config)
    
    return model
  }
}
