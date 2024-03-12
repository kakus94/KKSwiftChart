//
//  KKChartConfig.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//
import Foundation
import SwiftUI

@available(iOS 16.0, *)
/// Struktura reprezetujaca styl wykresu
public struct KKChartConfig {
  /// Kolor ruchomego pivota
  public var colorIndicator: Color = .blue
  /// Styl siatki w osi X
  public var gridX: GridStyle = .init()
  /// Styl Siatki w osi Y
  public var gridY: GridStyle = .init()
  
  public init(colorIndicator: Color = .blue,
              gridX: GridStyle = .init(),
              gridY: GridStyle = .init())
  {
    self.colorIndicator = colorIndicator
    self.gridX = gridX
    self.gridY = gridY
  }
  
  /// Struktura reprezetujaca styl siatki
  public struct GridStyle {
    /// Kolor siatki
    public var colorGrid: Color = .gray
    /// kolor kreski koło osi
    public var colorTick: Color = .clear
    /// Kolor wartości na osi
    public var colorLabel: Color = .gray
    
    public init(colorGrid: Color = .gray,
                colorTick: Color = .clear,
                colorLabel: Color = .gray)
    {
      self.colorGrid = colorGrid
      self.colorTick = colorTick
      self.colorLabel = colorLabel
    }
  }
}
