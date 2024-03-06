//
//  KKZoomingChart.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI
import Charts


public struct KKChartZooming: KKChartZoomingProtocol {
  
  public var includeFillChart: Bool
  
  public var seria: Dictionary<String, Color> = .init()
  
  public var values: [KKPointChart] = .init()
  
  public var config: KKChartConfig = .init()
  public var chartView: (any View)?
  
  var delegate: KKChartZoomingDelegate?
  
  public var min: Double?
  public var max: Double?
  
  public var domainY: ClosedRange = 0.0...10.0
  public var domainX: ClosedRange = Date.now...Date.now
  
  public init(fillChart: Bool) {
    self.includeFillChart = fillChart
  }
  
  //MARK: Render
  
  public var viewToRender: AnyView {
    AnyView(
      Chart {
        ForEach(self.values, id: \.id) { point in
          
          if includeFillChart {
            AreaMark(x: .value("time", point.x),
                     yStart: .value("value", point.y),
                     yEnd:  .value("value", min ?? 0))
            
            .interpolationMethod(.cardinal)
            .foregroundStyle(
              LinearGradient(colors: [point.color.opacity(0.2), .clear],
                             startPoint: .top,
                             endPoint: .bottom)
            )
            .foregroundStyle(by: .value("Seria", point.seria))
          }
            
            
            LineMark(x: .value("time", point.x),
                     y: .value("Temperatura w buforze CWU", point.y))
            
            .interpolationMethod(.cardinal)
            .lineStyle(.init(lineWidth: 1))
            .foregroundStyle(point.color)
            .foregroundStyle(by: .value("Seria", point.seria))
            
          }
        }
        .chartLegend(position: .top, alignment: .leading, spacing: 15)
        .chartLegend(.visible)
        
        .chartYScale(domain: domainY)
        .chartYAxis {
          AxisMarks(position: .leading,
                    values: .automatic(desiredCount: 5,
                                       roundLowerBound: nil,
                                       roundUpperBound: nil)) { _ in
            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1,2]))
              .foregroundStyle(config.gridY.colorGrid)
            AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
              .foregroundStyle(config.gridY.colorTick)
            AxisValueLabel()
              .foregroundStyle(config.gridY.colorLabel)
          }
        }
        
        .chartXScale(domain: domainX)
        .chartXAxis {
          AxisMarks(values: .automatic) { _ in
            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
              .foregroundStyle(config.gridX.colorGrid)
            AxisTick(stroke: StrokeStyle(lineWidth: 2))
              .foregroundStyle(config.gridX.colorTick)
            AxisValueLabel()
              .foregroundStyle(config.gridX.colorLabel)
          }
        }
      //        .chartForegroundStyleScale(self.seria)
        .chartForegroundStyleScale(
          domain: seriaDomain(),
          range: seriaRange()
        )
    )
  }
  
  
  @MainActor
  mutating func reRender(_ startDate: Date, _ endDate: Date, _ maxValue: Double, _ minValue: Double) {
    self.setDomainX(value1: startDate, value2: endDate)
    self.setDomainY(value1: minValue, value2: maxValue, margin: 0.2)
    self.render()
  }
  
  
  @MainActor
  mutating func reRender(_ startIndex: Int, _ endIndex: Int, _ maxValue: Double, _ minValue: Double) {
    let dates = [values[startIndex].x, values[endIndex].x]
    min = minValue
    max = maxValue
    domainY = min!...max!
    domainX = dates.min()!...dates.max()!
    self.render()
  }
  
  
  @MainActor
  mutating func renderOrginal() {
    let (newMin,newMax) = getMinMaxValue(values: self.values.map{$0.y})
    self.max = newMax
    self.min = newMin
    self.domainY = newMin!...newMax!
    self.setDomainX()
    self.render()
  }
}
