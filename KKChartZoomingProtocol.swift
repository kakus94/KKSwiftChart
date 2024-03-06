//
//  KKChartZoomingProtocol.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 05/03/2024.
//

import SwiftUI

protocol KKChartZoomingDelegate {
  var zoomingModel: ZoomingModel { get set }
  
  func setValue(newZoomingModel: ZoomingModel)
  func reRender(_ startDate: Date, _ endDate: Date, _ maxValue: Double, _ minValue: Double)
}


protocol KKChartZoomingProtocol: KKChartModelPrototol {
  
  var domainX: ClosedRange<Date>   { get set }
  var domainY: ClosedRange<Double> { get set }
  var delegate: KKChartZoomingDelegate?   { get set }
  

  
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>>
 
  /// Pobierz aktualną wyświetlaną wartość maksymalna ( os Y )
  /// - Returns: Wartość maksymalna
  func getMax() -> Double
  
  /// Pobierz aktualną wyświetlaną wartość minimalna ( os Y )
  /// - Returns: Wartość minimalna
  func getMin() -> Double
  
  
}


extension KKChartZoomingProtocol {
  
  func gesturePressDetect(geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
    DragGesture(minimumDistance: 0)
      .onChanged { value in
        delegate?.setValue(newZoomingModel: .init(value, show: true))
      }
      .onEnded { _ in
        calculate(geometry: geometry)
        delegate?.setValue(newZoomingModel: .init(nil, show: false))
      }
    
  }
  
  
  fileprivate func calculate(geometry: GeometryProxy) {
    
    guard let delegate else { return }
    
    let (newMax,newMin) = getNewMaxMinValue(geometry: geometry)
    
    if let newMax, let newMin,
       let startDate = find(location: delegate.zoomingModel.tapStart, geometry: geometry),
       let endDate   = find(location: .init(x: delegate.zoomingModel.tapStart.x + delegate.zoomingModel.transition.width, y: delegate.zoomingModel.tapStart.y),
                            geometry: geometry) {
      
      if !delegate.zoomingModel.revers {
        delegate.reRender(startDate, endDate, newMax, newMin)
      } else {
        let rangeDate = startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970
        let halfRange = rangeDate
        
        let startDate2 = domainX.lowerBound.timeIntervalSince1970 - halfRange
        let endDate2 = domainX.upperBound.timeIntervalSince1970 + halfRange
        
        delegate.reRender(Date(timeIntervalSince1970: startDate2), Date(timeIntervalSince1970: endDate2), newMax, newMin)
        
      }
    }
    
  }
  
  
  
  
  fileprivate func find(location: CGPoint, geometry: GeometryProxy) -> Date? {
    
    let domain = domainX
    let range = domain.upperBound.timeIntervalSince1970 - domain.lowerBound.timeIntervalSince1970
    
    let relativeXPosition = location.x
    let resolution = geometry.size.width / range
    
    let dateAdded = (relativeXPosition / resolution)
    
    let dataResult = dateAdded + domain.lowerBound.timeIntervalSince1970
    let dataSelected = Date(timeIntervalSince1970: dataResult)
    
    return dataSelected
    
  }
  
  
  func getNewMaxMinValue(geometry: GeometryProxy) -> (CGFloat?, CGFloat?) {
    print("#")
    guard let delegate else { return (nil, nil) }
    
    let min = getMin()
    let max = getMax()
    let resulutonY = max - min
    
    let tap = delegate.zoomingModel.tapStart.y
    let tap2 = tap + delegate.zoomingModel.transition.height
    
    print("\nmin:\(min) max:\(max)")
    
    let height = geometry.size.height
    let resolution = height / CGFloat(resulutonY)
    
    if !delegate.zoomingModel.revers {
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


struct ZoomingModel: Identifiable {
  let id = UUID().uuidString
  var tapStart: CGPoint = .zero
  var transition: CGSize = .zero
  var revers: Bool = false
  var isActive: Bool = false
  
  init(_ value: DragGesture.Value?, show: Bool) {
    if let value {
      self.tapStart = value.startLocation
      self.transition = value.translation
      self.revers = value.translation.width < 0
    }
    self.isActive = show
  }
  
  init() {}
  
  mutating func show() {
    self.isActive = true
  }
  
  mutating func hidden() {
    self.isActive = false
  }
  
  public func calculatePosition() -> CGPoint {
    if revers {
      return .init(x: tapStart.x + (transition.width / 2),
                   y: tapStart.y + (transition.height / 2))
    } else {
      return .init(x: tapStart.x + (transition.width / 2),
                   y: tapStart.y + (transition.height / 2))
    }
  }
}
