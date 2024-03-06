//
//  KKZoomingChartView.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import SwiftUI
import Charts

extension KKChartZoomingView: KKChartZoomingDelegate {
  func reRender(_ startDate: Date, _ endDate: Date, _ maxValue: Double, _ minValue: Double) {
    model.setDomainX(value1: startDate, value2: endDate)
    model.setDomainY(value1: maxValue, value2: minValue, margin: 0.2)
    Task {
      await model.render()
    }
  }
  
  
  func setValue(newZoomingModel: ZoomingModel) {
    self.zoomingModel = newZoomingModel
  }
  
  
}

public struct KKChartZoomingView: View {
  
  @State var model: KKChartZooming
  
  @State internal var zoomingModel: ZoomingModel = .init()
  
 public init(model: KKChartZooming) {
    self._model = State(wrappedValue: model)
  }
  
  public  var body: some View {
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
      model.delegate = self
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
          .gesture(model.gesturePressDetect(geometry: geo))
          .overlay {
            if zoomingModel.isActive {
              Rectangle()
                .foregroundStyle(zoomingModel.revers ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: abs(zoomingModel.transition.width), height: abs(zoomingModel.transition.height))
                .position(zoomingModel.calculatePosition())
            }
          }
      }
    }
  }
  
}


#Preview {
  KKChartZoomingView(model: KKChartZooming.mock(20))
    .frame(height: 350)
    .padding(.horizontal)
}


//MARK: Mock
extension KKChartZooming {
  public static func mock(_ count: Int = 30, colorIdicator: Color = .blue) -> KKChartZooming {
    
    var model = KKChartZooming(fillChart: true)
    var points: [KKPointChart] = .init()
    let date: Date = .now
    
    let config = KKChartConfig(colorIndicator: colorIdicator)
    
    for i in 0...count {
      points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                          y: Double.random(in: 10...35),
                          seria: "Seria1", color: .cyan))
    }
    
    for i in 0...count {
      points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                          y: Double.random(in: 10...35),
                          seria: "Seria2", color: .orange))
    }
    
    model.setValues(points)
    model.setConfig(config)
    
    return model
  }
}
