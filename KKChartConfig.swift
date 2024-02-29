//
//  KKChartConfig.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//
import Foundation
import SwiftUI

public struct KKChartConfig {
  
  public var colorIndicator: Color = .blue
  public var colorLineChart: Color = .blue
  public var chartStyle: ChartStyle = .init()
  public var gridX: GridStyle = .init()
  public var gridY: GridStyle = .init()
  
  public struct ChartStyle {
    public var colors: [Color] = [.blue.opacity(0.3), .clear]
    public var startPoint: UnitPoint = .top
    public var endPoint: UnitPoint = .bottom
  }
  
  public struct GridStyle {
    public var colorGrid: Color = .gray
    public var colorTick: Color = .clear
    public var colorLabel: Color = .gray
  }
  
}
