//
//  KKPointChart.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI
import KKHelper

public struct KKPointChart: Identifiable, CustomDebugStringConvertible {
  public var id = UUID().uuidString
  public var x: Date
  public var y: Double
  public var seria: String
  public var color: Color
  
  
  public var debugDescription: String {
    return "Result -> Date: \(x.format("dd HH:mm:ss")) value: \(y) seria: \(seria) color: \(color) "
     }
}
