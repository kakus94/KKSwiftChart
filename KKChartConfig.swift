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
  public var gridX: GridStyle = .init()
  public var gridY: GridStyle = .init()  
  
  public struct GridStyle {
    public var colorGrid: Color = .gray
    public var colorTick: Color = .clear
    public var colorLabel: Color = .gray
  }
  
}
