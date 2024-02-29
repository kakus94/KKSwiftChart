//
//  KKChartIndicator.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI
import Charts

//MARK: ChartModel
struct KKChartIndicator: KKChartModelPrototol {
  var includeFillChart: Bool
  
  var seria: KeyValuePairs<String, Color> = [:]
  
  var domainY: ClosedRange<Double> = 0...10
  var domainX: ClosedRange<Date> = Date.now.addingTimeInterval(-3600)...Date.now
  
  var values: [KKPointChart] = .init()
  
  var config: KKChartConfig = . init()
  var chartView: (any View)?
  
  var min: Double?
  var max: Double?
  
  var viewToRender: AnyView {
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
            //            .foregroundStyle(by: .value("Electrode", "Temperatura w buforze CWU"))
            .foregroundStyle(by: .value("Seria", point.seria))
            
          }
        }
        .chartLegend(position: .top, alignment: .leading, spacing: 15)
        .chartLegend(.visible)
      
        .chartYScale(domain: (min ?? 0)...(max ?? 10))
        .chartYAxis {
          AxisMarks(position: .leading, values: [min ?? 0, max ?? 10].generateValue(format: "%.1f", count: 5)) { _ in
            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1,2]))
              .foregroundStyle(config.gridY.colorGrid)
            AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
              .foregroundStyle(config.gridY.colorTick)
            AxisValueLabel()
              .foregroundStyle(config.gridY.colorLabel)
          }
        }
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
    )
    
  }
  
}




//MARK: Mock
extension KKChartIndicator {
  static func mock(_ count: Int = 30, colorChart: Color = .blue, colorIdicator: Color = .blue) -> KKChartIndicator {
    
    var model = KKChartIndicator(includeFillChart: true)
    var points: [KKPointChart] = .init()
    let date: Date = .now
    
    let config = KKChartConfig(colorIndicator: colorIdicator)
    
    for i in 0...count {
      points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                          y: Double.random(in: 10...35),
                          seria: "Seria", color: .green))
    }
    
    model.setValues(points)
    model.setConfig(config)
    
    return model
  }
}