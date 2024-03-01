//
//  KKChartSearchProtocol.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 01/03/2024.
//

import Foundation
import SwiftUI
import Charts

protocol KKChartDelegate {
  
}



protocol KKChartSearchProtocol {
  
  var selectedElement: Date? { get set }
  var domainX: ClosedRange<Date>   { get set }
  var domainY: ClosedRange<Double> { get set}
  
  
  func resulutionY() -> Double
  func gesturePressDetect(proxy: ChartProxy, geometry: GeometryProxy) -> any Gesture
}


extension KKChartSearchProtocol {
  
  func find(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
    
  }
  
  func resulutionY() -> Double {
    let resY: Double = Double(domainY.lowerBound - domainY.upperBound)
    return resY
  }
  
  func gesturePressDetect(proxy: ChartProxy, geometry: GeometryProxy) -> any Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
//        selectedElement = find(location: value.location,
//                               proxy: proxy,
//                               geometry: geometry)
      }
      .onEnded { _ in
//        selectedElement = nil
      }
  }
  
  
  func getChartFrame(proxy: ChartProxy, geo: GeometryProxy) -> (Double, Double) {
    let chartWidth  = geo[proxy.plotFrame!].width
    let chartHeight = geo[proxy.plotFrame!].height
    return (chartWidth, chartHeight)
  }
  
  func getRelativePosition(proxy: ChartProxy, geo: GeometryProxy) -> (Double, Double) {
    let x  = geo[proxy.plotFrame!].origin.x
    let y = geo[proxy.plotFrame!].origin.y
    return (x, y)
  }

  
}





protocol KKChartPositionIndicatorProtocol {
  
  
  
  
}


extension KKChartPositionIndicatorProtocol {

}
 
