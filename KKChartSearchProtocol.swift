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
  func setSelectedElement(result: [KKChartPositionIndicator?]?)
  func getValues() -> [KKPointChart]
  func getSeries() -> Dictionary<String, Color>
}





protocol KKChartSearchProtocol {
  
  var domainX: ClosedRange<Date>   { get set }
  var domainY: ClosedRange<Double> { get set }
  var delegate: KKChartDelegate? { get set }
  func resulutionY() -> Double
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>>
}


extension KKChartSearchProtocol {
  
  func findPoint(_ date: Date?, width: CGFloat, height: CGFloat) {
    if let date, let delegate {
      let valueSorted = delegate.getValues().sorted(by: { $0.x < $1.x })
      let series = delegate.getSeries()
      
      var result: [KKChartPositionIndicator?] = []
      
      for (key,color) in series  {
        
        let x = valueSorted.last { poinChart in
          if  poinChart.seria == key && poinChart.x < date {
            return true
          }
          return false
        }
        
        if let x {
          
          let posX = (x.x.timeIntervalSince1970 - domainX.lowerBound.timeIntervalSince1970) / (domainX.upperBound.timeIntervalSince1970 - domainX.lowerBound.timeIntervalSince1970) * width
          let posY = x.y / (domainY.upperBound - domainY.lowerBound) * height
          
          result.append(.init(result: x, posX: posX, posY: posY, date: date))
        }
        
      }
      
      
      delegate.setSelectedElement(result: result)
    }
    
  }
  
  func find(location: CGPoint, geometry: GeometryProxy) {
    
    let (relX, relY) = getRelativePosition(geo: geometry)
    let rangeY = domainX.upperBound.timeIntervalSince1970 - domainX.lowerBound.timeIntervalSince1970
    let timeInterval = ((location.x / relX) * rangeY) + domainX.lowerBound.timeIntervalSince1970
    let selectData = Date(timeIntervalSince1970: TimeInterval(timeInterval))
    
    findPoint(selectData, width: relX, height: relY)
  }
  
  func resulutionY() -> Double {
    let resY: Double = Double(domainY.lowerBound - domainY.upperBound)
    return resY
  }
  
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
       find(location: value.location, geometry: geometry)
      }
      .onEnded { _ in
        delegate?.setSelectedElement(result: nil)
      }
  }
  
  
  func getChartFrame(proxy: ChartProxy, geo: GeometryProxy) -> (Double, Double) {
    let chartWidth  = geo[proxy.plotFrame!].width
    let chartHeight = geo[proxy.plotFrame!].height
    return (chartWidth, chartHeight)
  }
  
  func getRelativePosition( geo: GeometryProxy) -> (Double, Double) {
    let x  = geo.size.width
    let y = geo.size.height
    return (x, y)
  }

  
}





public struct KKChartPositionIndicator: Equatable {
  public static func == (lhs: KKChartPositionIndicator, rhs: KKChartPositionIndicator) -> Bool {
    lhs.posX != rhs.posX || lhs.posY != rhs.posY || lhs.date != rhs.date
  }
  
  public var result: KKPointChart
  public var posX: CGFloat
  public var posY: CGFloat
  public var date: Date
  
  public init(result: KKPointChart, posX: CGFloat, posY: CGFloat, date: Date) {
    self.result = result
    self.posX = posX
    self.posY = posY
    self.date = date
  }
}


 
