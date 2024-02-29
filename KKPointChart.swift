//
//  KKPointChart.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI

public struct KKPointChart: Identifiable {
  public var id = UUID().uuidString
  public var x: Date
  public var y: Double
  public var seria: String
  public var color: Color
}
