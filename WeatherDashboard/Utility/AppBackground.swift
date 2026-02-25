//
//  AppBackground.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation

enum AppBackground: String, CaseIterable, Identifiable {
    case aurora
    case sunset
    case ocean
    case midnight
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .aurora: return "Aurora"
        case .sunset: return "Sunset"
        case .ocean: return "Ocean"
        case .midnight: return "Midnight"
        }
    }
}
