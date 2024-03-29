//
//  KKChartIndicator.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Charts
import Foundation
import SwiftUI

// MARK: ChartModel

@available(iOS 16.0, *)
public struct KKChartIndicator: KKChartSearchProtocol {
    public var includeFillChart: Bool
    public var seria: [String: Color] = [:]

    public var domainY: ClosedRange<Double> = 0 ... 10
    public var domainX: ClosedRange<Date> = Date.now.addingTimeInterval(-3600) ... Date.now

    public var values: [KKPointChart] = .init()

    public var config: KKChartConfig = .init()
    public var chartView: (any View)?

    public var min: Double?
    public var max: Double?

    public var interpolationMethod: InterpolationMethod = .cardinal

    public var delegate: KKChartSearchDelegate?

    public init(fillChart: Bool, interpolationMethod: InterpolationMethod) {
        includeFillChart = fillChart
        self.interpolationMethod = interpolationMethod
    }

    public var viewToRender: AnyView {
        AnyView(
            Chart {
                ForEach(self.values, id: \.id) { point in

                    if includeFillChart {
                        AreaMark(x: .value("time", point.x),
                                 yStart: .value("value", point.y),
                                 yEnd: .value("value", min ?? 0))

                            .interpolationMethod(interpolationMethod)
                            .foregroundStyle(
                                LinearGradient(colors: [point.color.opacity(0.2), .clear],
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                            .foregroundStyle(by: .value("Seria", point.seria))
                    }

                    LineMark(x: .value("time", point.x),
                             y: .value("Temperatura w buforze CWU", point.y))

                        .interpolationMethod(interpolationMethod)
                        .lineStyle(.init(lineWidth: 1))
                        .foregroundStyle(point.color)
                        .foregroundStyle(by: .value("Seria", point.seria))
                }
            }
            .chartLegend(position: .top, alignment: .leading, spacing: 15)
            .chartLegend(.visible)

            .chartYScale(domain: domainY)
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 5, roundLowerBound: nil, roundUpperBound: nil)) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                        .foregroundStyle(config.gridY.colorGrid)
                    AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(config.gridY.colorTick)
                    AxisValueLabel()
                        .foregroundStyle(config.gridY.colorLabel)
                }
            }

            .chartXScale(domain: domainX)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 8)) { _ in
                    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                        .foregroundStyle(config.gridX.colorGrid)
                    AxisTick(stroke: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(config.gridX.colorTick)
                    AxisValueLabel()
                        .foregroundStyle(config.gridX.colorLabel)
                }
            }
            .chartForegroundStyleScale(domain: seriaDomain(),
                                       range: seriaRange())
        )
    }
}

// MARK: Mock

@available(iOS 16.0, *)
public extension KKChartIndicator {
    static func mock(_ count: Int = 15, colorChart _: Color = .blue, colorIdicator: Color = .blue, interpolationMethod: InterpolationMethod = .linear) -> KKChartIndicator {
        var model = KKChartIndicator(fillChart: false, interpolationMethod: interpolationMethod)
        var points: [KKPointChart] = .init()
        let date: Date = .now

        let config = KKChartConfig(colorIndicator: colorIdicator)

        for i in 0 ... count {
            points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 60)),
                                y: Double.random(in: 10 ... 35),
                                seria: "Seria2", color: .red))
        }

        for i in 0 ... count {
            points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 60)),
                                y: Double.random(in: 10 ... 35),
                                seria: "Seria1", color: .green))
        }

        for i in 0 ... count {
            points.append(.init(x: date.addingTimeInterval(TimeInterval(i * 60)),
                                y: Double.random(in: 10 ... 35),
                                seria: "Seria3", color: .mint))
        }

        model.setValues(points)
        model.setConfig(config)

        return model
    }
}
