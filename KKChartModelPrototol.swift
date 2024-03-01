//
//  KKChartModelPrototol.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Foundation
import SwiftUI
import Charts


protocol KKChartModelPrototol {
  
  var values: [KKPointChart] { get set }
  var config: KKChartConfig { get set }
  
  var viewToRender: AnyView { get }
  var chartView: (any View)? { get set }
  
  var min: Double? { get set }
  var max: Double? { get set }
  
  var domainY: ClosedRange<Double> { get set }
  var domainX: ClosedRange<Date> { get set }
  
  var seria: Dictionary<String, Color> { get set }
  
  var includeFillChart: Bool { get set }
  
  mutating func render()
  mutating func setValues(_ values: [KKPointChart])
  mutating func setConfig(_ config: KKChartConfig)
  
  /// Zwraca wartość maksymalna i minimalna z podanej tablicy
  /// - Parameter values: Tablica danych
  /// - Returns: (wartość minimalna, wartość maksymalna)
  func getMinMaxValue(values: [Double]) -> (Double?,Double?)
  
  /// Funkcja zwraca wartość z tablic wzgledem indexu
  /// - Parameter index: Index do danych w tablicy
  /// - Returns: Wartość
  func getValueByIndex(by index: Int) -> Double
  
  /// Zwraca liczbę danych
  /// - Returns: Ilość danych
  func getCount() -> Int
  
  /// Pobierz aktualną wyświetlaną wartość maksymalna ( os Y )
  /// - Returns: Wartość maksymalna
  func getMax() -> Double
  
  /// Pobierz aktualną wyświetlaną wartość minimalna ( os Y )
  /// - Returns: Wartość minimalna
  func getMin() -> Double
    
  /// Funkcja ustawia zakres osi X
  /// Kolejność parametrów nie ma znaczenia
  /// - Parameters:
  ///   - value1: Pierwsza wartość
  ///   - value2: Druga wartość
  mutating func setDomainX(value1: Date, value2: Date)
  
  /// Funkcja ustawia zakres osi X zgodnie z danymi
  /// Obejmuje cały zakres danych
  mutating func setDomainX()
  
  /// Funkcja ustawia zakres osi Y
  /// Kolejność parametrów nie ma znaczenia
  /// - Parameters:
  ///   - value1: Pierwsza wartość
  ///   - value2: Druga wartość
  ///   - margin: Procentowy odstep
  mutating func setDomainY(value1: Double, value2: Double, margin: Double)
  
  /// Funkcja ustawia zakres osi Y zgodnie z danymi
  /// Obejmuje cały zakres danych
  /// - Parameter margin: Procentowy odstep
  mutating func setDomainY(margin: Double)
  
  func seriaDomain() -> [String]
  func seriaRange() -> [Color]
}


extension KKChartModelPrototol {
  
  func seriaDomain() -> [String] {
    seria.map({ $0.key })
  }
  
  func seriaRange() -> [Color] {
    seria.map({ $0.value })
  }
 
  mutating func setSeries() {
    
    var dict: Dictionary<String,Color> = .init()
    values.forEach { kKPointChart in
      dict[kKPointChart.seria] = kKPointChart.color
    }
    self.seria = dict    
  }
  
  mutating func sortValue() {
    self.values = self.values.sorted(by: {$0.seria < $1.seria})
  }
  
  @MainActor
  mutating func render() {
    sortValue()
    setSeries()
      let render = ImageRenderer(content: viewToRender)
      render.scale = UIScreen.main.scale
      self.chartView = render.content
  }
    
  func getMinMaxValue(values: [Double]) -> (Double?,Double?) {
    let min = (values.min() ?? 0)
    let max = (values.max() ?? 10)
    
    let rangePrecentStep = (max - min) * 0.1
    
    return (min - rangePrecentStep, max + rangePrecentStep)
  }
    
  mutating func setValues(_ values: [KKPointChart]) {
    self.values = values.sorted(by: { $0.x < $1.x })
    let (minn,maxx) = getMinMaxValue(values: self.values.map{ $0.y })
    self.min = minn
    self.max = maxx
  }
    
  mutating func setConfig(_ config: KKChartConfig) {
    self.config = config
  }
    
  func getValueByIndex(by index: Int) -> Double {
    values[index].y
  }
    
  func getCount() -> Int {
    values.count
  }
  
  func getMax() -> Double {
    max ?? 10
  }
  
  func getMin() -> Double {
    min ?? 0
  }
  
  mutating func setDomainX(value1: Date, value2: Date) {
    let x = [value1, value2]
    let orginalStartDate = self.values.map({ $0.x }).min()
    let orginalEndDate = self.values.map({ $0.x }).max()
    
    var resultStart: Date = x.min()!
    var resultEnd: Date = x.max()!
    
    if let orginalStartDate, orginalStartDate > resultStart {
      resultStart = orginalStartDate
    }
    
    if let orginalEndDate, orginalEndDate < resultEnd {
      resultEnd = orginalEndDate
    }
    
    self.domainX = resultStart...resultEnd
  }
  
  mutating func setDomainX() {
    let dates = values.map{ $0.x }
    setDomainX(value1: dates.max()!, value2: dates.min()!)
  }
  
  mutating func setDomainY(value1: Double, value2: Double, margin: Double = 0) {
    
    let values = [value1, value2]
    let orginalMin = self.values.map({ $0.y }).min()
    let orginalMax = self.values.map({ $0.y }).max()
    var resultMin: Double = values.min()!
    var resultMax: Double = values.max()!
    
    if let orginalMin, orginalMin > resultMin {
      resultMin = orginalMin
    }
    
    if let orginalMax, orginalMax < resultMax {
      resultMax = orginalMax
    }
    
    let range = (resultMax - resultMin)
    let toAdd = range * margin / 2
    
    self.domainY = (resultMin - toAdd)...(resultMax + toAdd)
  }
  
  mutating func setDomainY(margin: Double = 0) {
    
    let mappingValue = values.map({ $0.y })
    
    let minValue = mappingValue.min() ?? 0
    let maxValue = mappingValue.max() ?? 10
    
    let range = (maxValue - minValue)
    
    let toAdd = range * margin / 2
    self.domainY = (minValue - toAdd )...(maxValue + toAdd)
  
  }
  
}

struct ChartConfig {
  
  var colorIndicator: Color = .blue
  var colorLineChart: Color = .blue
  var chartStyle: ChartStyle = .init()
  var gridX: GridStyle = .init()
  var gridY: GridStyle = .init()
  
  struct ChartStyle {
    var colors: [Color] = [.blue.opacity(0.3), .clear]
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom
  }
  
  struct GridStyle {
    var colorGrid: Color = .gray
    var colorTick: Color = .clear
    var colorLabel: Color = .gray
  }
  
}
