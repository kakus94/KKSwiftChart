//
//  KKChartModelPrototol.swift
//  KKSwiftChart
//
//  Created by Kamil Karpiak on 29/02/2024.
//

import Charts
import Foundation
import SwiftUI

@available(iOS 16.0, *)
public protocol KKChartModelPrototol {
  
  /// Ustawianie watrości powinno być realizowane za pomoca funkcji **setValues(_ values: [KKPointChart])**
  ///
  /// Zapisz nowe tablice punktów
  ///```swift
  ///setValues(_ values: [KKPointChart])
  ///```
  /// - Note: Jeśli przypiszesz watrość bez funcji to nie zostaną zaktualizowane wartości **min, max, serii i zakresu osi X i Y**
  var values: [KKPointChart] { get set }
  
  /// Ustawianie watrości powinno być realizowane za pomoca funkcji **setConfig(_ config: KKChartConfig)**
  ///
  /// **Implementacja:**
  ///```swift
  /// Chart { }
  ///  .chartYAxis {
  ///   AxisMarks(position: .leading, values: .automatic(desiredCount: 5, roundLowerBound: nil, roundUpperBound: nil)) { _ in
  ///    AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
  ///        .foregroundStyle(config.gridY.colorGrid)
  ///    AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
  ///        .foregroundStyle(config.gridY.colorTick)
  ///    AxisValueLabel()
  ///        .foregroundStyle(config.gridY.colorLabel)
  ///  }
  /// }
  ///   .chartXAxis {
  ///  AxisMarks(values: .automatic(desiredCount: 8)) { _ in
  ///      AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
  ///          .foregroundStyle(config.gridX.colorGrid)
  ///      AxisTick(stroke: StrokeStyle(lineWidth: 2))
  ///          .foregroundStyle(config.gridX.colorTick)
  ///      AxisValueLabel()
  ///          .foregroundStyle(config.gridX.colorLabel)
  ///  }
  ///}
  ///```
  var config: KKChartConfig { get set }
  
  ///Zmienna powinna zawierać kod wykresu który zostanie wrenderowany do obrazu statycznego
  ///
  /// **Implementacja:**
  /// ```swift
  ///AnyView(
  ///    Chart {
  ///        ForEach(self.values, id: \.id) { point in
  ///
  ///            LineMark(x: .value("time", point.x),
  ///                     y: .value("Temperatura w buforze CWU", point.y))
  ///
  ///                .interpolationMethod(interpolationMethod)
  ///                .lineStyle(.init(lineWidth: 1))
  ///                .foregroundStyle(point.color)
  ///                .foregroundStyle(by: .value("Seria", point.seria))
  ///        }
  ///    }
  ///    //Configuracja osi Y
  ///    .chartYScale(domain: domainY)
  ///    .chartYAxis {
  ///        AxisMarks(position: .leading, values: .automatic(desiredCount: 5, roundLowerBound: nil, roundUpperBound: nil)) { _ in
  ///            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
  ///                .foregroundStyle(config.gridY.colorGrid)
  ///            AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 2))
  ///                .foregroundStyle(config.gridY.colorTick)
  ///            AxisValueLabel()
  ///                .foregroundStyle(config.gridY.colorLabel)
  ///        }
  ///    }
  /////Configuracja osi X
  ///    .chartXScale(domain: domainX)
  ///    .chartXAxis {
  ///        AxisMarks(values: .automatic(desiredCount: 8)) { _ in
  ///            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
  ///                .foregroundStyle(config.gridX.colorGrid)
  ///            AxisTick(stroke: StrokeStyle(lineWidth: 2))
  ///                .foregroundStyle(config.gridX.colorTick)
  ///            AxisValueLabel()
  ///                .foregroundStyle(config.gridX.colorLabel)
  ///        }
  ///    }
  ///    //Configuracja legendy
  ///    .chartLegend(position: .top, alignment: .leading, spacing: 15)
  ///    .chartLegend(.visible)
  ///    .chartForegroundStyleScale(domain: seriaDomain(),
  ///                               range: seriaRange())
  ///)
  /// ```
    var viewToRender: AnyView { get }
  
  /// Ta wartość przetrzymuje wyrenderowany wykres
    var chartView: (any View)? { get set }

    var min: Double? { get set }
    var max: Double? { get set }

  ///Reprezetuje zakres danych na osi Y
  ///
  /// **Implementacja:**
  ///```swift
  /// Chart { }
  /// .chartYScale(domain: domainY)
  ///```
    var domainY: ClosedRange<Double> { get set }
  
  ///Reprezetuje zakres danych na osi X
  ///
  /// **Implementacja:**
  ///```swift
  /// Chart { }
  /// .chartXScale(domain: domainX)
  ///```
    var domainX: ClosedRange<Date> { get set }

  
  /// Reprezetuje serie jest tworzone automatycznie podczas ustawiania
  /// podawania punktow wykresu
  /// wymagane jedynie uzycie funkcji **setValues(_ )** do ustawienia wartosci
  ///
  ///  **Implementacja:**
  ///  ```swift
  ///  Chart{}
  ///  .chartForegroundStyleScale(domain: seriaDomain(),
  ///                               range: seriaRange())
  ///  ```
    var seria: [String: Color] { get set }
  
  /// Funkcja zamienia widok zawarty w zmiennej **viewToRender** do statycznego widoku
  /// wynik zapisywany jest w zmiennej **chartView**
    mutating func render()
  
  /// Funcja przypiuje wartości wykresu i procesuje wartości **min, max, seria i zakresy osi XY**
  /// - Parameter values: Tablica punktów wykresu
    mutating func setValues(_ values: [KKPointChart])
  
  /// Funkcja przypisuje config wykresu
  /// - Parameter config: KKChartConfig
    mutating func setConfig(_ config: KKChartConfig)

    /// Zwraca wartość maksymalna i minimalna z podanej tablicy
    /// - Parameter values: Tablica danych
    /// - Returns: (wartość minimalna, wartość maksymalna)
    func getMinMaxValue(values: [Double]) -> (Double?, Double?)

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
  
  /// Funkcja zwraca domeny (nazwa serii zawartych w punktach wykresu)
  /// - Returns: Tablica serii
  func seriaDomain() -> [String]
  
  ///  Funkcja zwraca colory dla dannych serii (kolory powiazane z seria wyciagnięte z punktów wykresu )
  /// - Returns: Tablica kolorow
    func seriaRange() -> [Color]
}

@available(iOS 16.0, *)
public extension KKChartModelPrototol {
    func seriaDomain() -> [String] {
        seria.map { $0.key }
    }

    func seriaRange() -> [Color] {
        seria.map { $0.value }
    }

    mutating func setSeries() {
        var dict: [String: Color] = .init()
        values.forEach { kKPointChart in
            dict[kKPointChart.seria] = kKPointChart.color
        }
        seria = dict
    }

    mutating func sortValue() {
        values = values.sorted(by: { $0.seria < $1.seria })
    }

    @available(iOS 16.0, *)
    @MainActor
    mutating func render() {
        sortValue()
        setSeries()
        let render = ImageRenderer(content: viewToRender)
        render.scale = UIScreen.main.scale
        chartView = render.content
    }

    func getMinMaxValue(values: [Double]) -> (Double?, Double?) {
        let min = (values.min() ?? 0)
        let max = (values.max() ?? 10)

        let rangePrecentStep = (max - min) * 0.1

        return (min - rangePrecentStep, max + rangePrecentStep)
    }

    mutating func setValues(_ values: [KKPointChart]) {
        self.values = values
        let (minn, maxx) = getMinMaxValue(values: self.values.map { $0.y })
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
        let orginalStartDate = values.map { $0.x }.min()
        let orginalEndDate = values.map { $0.x }.max()

        var resultStart: Date = x.min()!
        var resultEnd: Date = x.max()!

        if let orginalStartDate, orginalStartDate > resultStart {
            resultStart = orginalStartDate
        }

        if let orginalEndDate, orginalEndDate < resultEnd {
            resultEnd = orginalEndDate
        }

        domainX = resultStart ... resultEnd
    }

    mutating func setDomainX() {
        let dates = values.map { $0.x }
      setDomainX(value1: dates.max() ?? .now, value2: dates.min() ?? .now)
    }

    mutating func setDomainY(value1: Double, value2: Double, margin: Double = 0) {
        let values = [value1, value2]
        let orginalMin = self.values.map { $0.y }.min()
        let orginalMax = self.values.map { $0.y }.max()
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

        domainY = (resultMin - toAdd) ... (resultMax + toAdd)
    }

    mutating func setDomainY(margin: Double = 0) {
        let mappingValue = values.map { $0.y }

        let minValue = mappingValue.min() ?? 0
        let maxValue = mappingValue.max() ?? 10

        setDomainY(value1: minValue, value2: maxValue, margin: margin)
    }
  
  
  mutating func firstRender(margin: Double = 0.1) {
    setDomainX()
    setDomainY(margin: margin)
    render()
  }
  
  mutating func firstRender(margin: Double = 0.1, values: [KKPointChart]) {
    setValues(values)
    firstRender(margin: margin)
  }
}
