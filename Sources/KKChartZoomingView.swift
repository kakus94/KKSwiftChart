//
//  KKZoomingChartView.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Charts
import SwiftUI

@available(iOS 16.0, *)
extension KKChartZoomingView: KKChartZoomingDelegate {
    public func reRender(_ startDate: Date, _ endDate: Date, _ maxValue: Double, _ minValue: Double) {
        model.setDomainX(value1: startDate, value2: endDate)
        model.setDomainY(value1: maxValue, value2: minValue, margin: 0.2)
        Task {
            await model.render()
        }
    }

    public func setValue(newZoomingModel: ZoomingModel) {
        zoomingModel = newZoomingModel
    }
}

@available(iOS 16.0, *)
public struct KKChartZoomingView: View {
    @State var model: KKChartZooming

    @State public var zoomingModel: ZoomingModel = .init()

    public init(model: KKChartZooming) {
        _model = State(wrappedValue: model)
    }

    public var body: some View {
        VStack {
            if let chartView = model.chartView {
                AnyView(chartView)
                    .chartPlotStyle { plotContent in
                        plotContent
                            .overlay(content: { model.overlay(zoomingModel) })
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

@available(iOS 16.0, *)
#Preview {
    KKChartZoomingView(model: KKChartZooming.mock(20))
        .frame(height: 350)
        .padding(.horizontal)
}

// MARK: Mock

@available(iOS 16.0, *)
public extension KKChartZooming {
    static func mock(_ count: Int = 30, colorIdicator: Color = .blue) -> KKChartZooming {
        var model = KKChartZooming(includeFillChart: true)
        var points: [KKPointChart] = .init()
        let date: Date = .now

        let config = KKChartConfig(colorIndicator: colorIdicator)

        for i in 0 ... count {
            points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                                y: Double.random(in: 10 ... 35),
                                seria: "Seria1", color: .cyan))
        }

        for i in 0 ... count {
            points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 3600)),
                                y: Double.random(in: 10 ... 35),
                                seria: "Seria2", color: .orange))
        }

        model.setValues(points)
        model.setConfig(config)

        return model
    }
}
