//
//  TemperatureUnit.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius
    case fahrenheit
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .celsius: return "Celsius (°C)"
        case .fahrenheit: return "Fahrenheit (°F)"
        }
    }
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}

// Helper functions for temperature conversion and formatting.
enum TemperatureFormatter {
    static func convertFromCelsius(_ c: Double, to unit: TemperatureUnit) -> Double {
        switch unit {
        case .celsius: return c
        case .fahrenheit: return (c * 9.0 / 5.0) + 32.0
        }
    }
    
    static func intString(fromCelsius c: Double, unit: TemperatureUnit) -> String {
        let v = convertFromCelsius(c, to: unit)
        return "\(Int(v.rounded()))\(unit.symbol)"
    }
    
    static func double(fromCelsius c: Double, unit: TemperatureUnit) -> Double {
        convertFromCelsius(c, to: unit)
    }
}
