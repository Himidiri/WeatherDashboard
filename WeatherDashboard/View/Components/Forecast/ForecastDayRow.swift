//
//  ForecastDayRow.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct ForecastDayRow: View {
    @AppStorage("tempUnit") private var tempUnit: TemperatureUnit = .celsius
    let day: Daily

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(dayTitle)
                .font(.headline)
            Text(daySummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                Text("Low: \(TemperatureFormatter.intString(fromCelsius: lowC, unit: tempUnit))")
                Text("High: \(TemperatureFormatter.intString(fromCelsius: highC, unit: tempUnit))")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var lowC: Double { day.temp.min }
    private var highC: Double { day.temp.max }

    private var dayTitle: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d"
        return df.string(from: Date(timeIntervalSince1970: TimeInterval(day.dt)))
    }

    private var daySummary: String {
        let s = day.summary.trimmingCharacters(in: .whitespacesAndNewlines)
        if !s.isEmpty { return s }
        return (day.weather.first?.description ?? "—").capitalized
    }
}
