//
//  AppTheme.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }
}
