//
//  KKPointChart.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
/// Reprezentuje pojedynczy punkt na wykresie
public struct KKPointChart: Identifiable, CustomDebugStringConvertible {
  /// Unikalnyy identificator punktu
    public var id = UUID().uuidString
  /// Oś X w postaci daty
    public var x: Date
  /// Oś Y
    public var y: Double
  ///Seria punktu
    public var seria: String
  ///Color wykresu
    public var color: Color

    public var debugDescription: String {
        return "Result -> Date: \(x.format("dd HH:mm:ss")) value: \(y) seria: \(seria) color: \(color) "
    }

    public init(x: Date, y: Double, seria: String, color: Color) {
        self.x = x
        self.y = y
        self.seria = seria
        self.color = color
    }
}

@available(iOS 15, *)
public extension [KKPointChart] {
    static func mockArray(_ countPoint: Int = 20, _ countPlot: Int = 1) -> Self {
        let colors: [Color] = [.red, .green, .blue, .yellow, .brown, .cyan, .indigo, .mint, .orange, .teal]
        var points: Self = []
      
      var safePlotCount = countPlot
      if countPlot < 1 {
        safePlotCount = 1
      }
      
        for plotIndex in 0 ... (safePlotCount - 1) {
            let color: Color = colors.randomElement()!
            for i in 0 ... countPoint {
                points.append(.init(x: .now.addingTimeInterval(TimeInterval(i * 60)),
                                    y: Double.random(in: 10 ... 15),
                                    seria: "Seria\(plotIndex)",
                                    color: color))
            }
        }

        return points
    }
}


extension Date {
  
  public func format(_ formatString: String =  "dd.MMMM HH:mm:ss") -> String {

    // Create an instance of Date (for demonstration, this is the current date and time)
    let currentDate = Date()

    // Initialize DateFormatter
    let dateFormatter = DateFormatter()

    // Set the desired format
    dateFormatter.dateFormat = formatString

    // Optionally, you can also set the locale if you want to force a specific language
    dateFormatter.locale = .current

    // Convert Date to String
    let dateString = dateFormatter.string(from: currentDate)

    return dateString

  }
  
}


