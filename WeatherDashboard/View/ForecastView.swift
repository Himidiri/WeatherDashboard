//
//  ForecastView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import Charts
import SwiftData

// MARK: - Temperature Data Model

// Chart model: one bar per value (Low/High) per day.
private struct TempBar: Identifiable {
    let id: String
    let dayKey: String
    let dayLabel: String
    let type: String         // "Low" or "High"
    let value: Double        // display value (C or F)
    let celsiusValue: Double // always Celsius (for color/advice)
}

struct ForecastView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @AppStorage("tempUnit") private var tempUnit: TemperatureUnit = .celsius
    
    // Daily forecast array from API.
    private var daily: [Daily] {
        vm.weatherResponse?.daily ?? []
    }
    
    // Only the next 8 days.
    private var first8Days: [Daily] {
        Array(daily.prefix(8))
    }
    
    // Builds chart points (two bars per day: Low + High).
    private var chartData: [TempBar] {
        first8Days.enumerated().flatMap { (idx, d) in
            let label = shortWeekday(from: d.dt)
            
            let lowC = d.temp.min
            let highC = d.temp.max
            
            let lowDisplay  = TemperatureFormatter.double(fromCelsius: lowC, unit: tempUnit)
            let highDisplay = TemperatureFormatter.double(fromCelsius: highC, unit: tempUnit)
            
            return [
                TempBar(id: "\(idx)-low-\(d.dt)",  dayKey: "\(idx)", dayLabel: label, type: "Low",
                        value: lowDisplay,  celsiusValue: lowC),
                
                TempBar(id: "\(idx)-high-\(d.dt)", dayKey: "\(idx)", dayLabel: label, type: "High",
                        value: highDisplay, celsiusValue: highC)
            ]
        }
    }
    
    private var tickStep: Double { tempUnit == .celsius ? 5.0 : 10.0 }
    private var rawMin: Double { chartData.map(\.value).min() ?? 0 }
    private var rawMax: Double { chartData.map(\.value).max() ?? 0 }
    private var yMin: Double {
        let minV = min(rawMin, 0)
        return floor(minV / tickStep) * tickStep
    }
    private var yMax: Double {
        let maxV = max(rawMax, 0)
        let rounded = ceil(maxV / tickStep) * tickStep
        return (rounded == yMin) ? (rounded + tickStep) : rounded
    }
    private var yTicks: [Double] {
        guard yMax >= yMin else { return [] }
        return Array(stride(from: yMin, through: yMax, by: tickStep))
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Text("8 Day Forecast - \(vm.activePlaceName.isEmpty ? "London" : vm.activePlaceName)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
                Text("Daily Highs and Lows (\(tempUnit.symbol))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Chart(chartData) { item in
                    BarMark(
                        x: .value("Day", item.dayKey),
                        y: .value("Temp", item.value)
                    )
                    .foregroundStyle(WeatherAdviceCategory.from(temp: item.celsiusValue).color)
                    .position(by: .value("Type", item.type))
                    .cornerRadius(5)
                }
                .frame(height: 240)
                .chartLegend(.hidden)
                .chartYScale(domain: yMin...yMax)
                
                // X-axis labels: show weekday for each of the 8 items (0...7).
                .chartXAxis {
                    AxisMarks(values: first8Days.indices.map { "\($0)" }) { axisValue in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let key = axisValue.as(String.self),
                               let idx = Int(key),
                               idx >= 0,
                               idx < first8Days.count {
                                
                                Text(shortWeekday(from: first8Days[idx].dt))
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                        }
                    }
                }
                
                // Y-axis labels.
                .chartYAxis {
                    AxisMarks(position: .trailing, values: yTicks) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let v = value.as(Double.self) {
                                Text("\(Int(v))°")
                                    .foregroundColor(.primary.opacity(0.7))
                            }
                        }
                    }
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(.white.opacity(0.10))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Divider()
                
                Text("Detailed Daily Summary")
                    .font(.headline)
                    .padding(.bottom, 15)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(first8Days.enumerated()), id: \.offset) { i, d in
                            ForecastDayRow(day: d)
                            
                            if i < first8Days.count - 1 {
                                Divider()
                                    .overlay(Color.white.opacity(0.1))
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                )
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func shortWeekday(from timestamp: Int) -> String {
        let df = DateFormatter()
        df.dateFormat = "EEE"
        return df.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    ForecastView()
        .environmentObject(vm)
}
