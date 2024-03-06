//
//  KKChartZoomingProtocol.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 05/03/2024.
//

import SwiftUI

protocol KKChartZoomingDelegate {
  func getValues() -> [KKPointChart]
  func getSeries() -> Dictionary<String, Color>
}


protocol KKChartZoomingProtocol {
  
  var domainX: ClosedRange<Date>   { get set }
  var domainY: ClosedRange<Double> { get set }
  var delegate: KKChartZoomingDelegate?   { get set }
  
  var tapStart: CGPoint { get set }
  var transition: CGSize { get set }
  var revers: Bool { get set }
  var show: Bool { get set }
  
  
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>>
  
  
  
}


extension KKChartZoomingProtocol {
  
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
//        self.tapStart = value.startLocation
//        self.transition = value.translation
//        self.revers = value.translation.width < 0
//        self.show = true
        
      }
      .onEnded { _ in
//        calculate(geometry: geometry)
//        self.show = false
      }
    
  }
  
  
}
