//
//  VisitedGradientBackground.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct VisitedGradientBackground: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Environment(\.colorScheme) private var systemScheme
    
    private var isDark: Bool {
        switch appTheme {
        case .dark: return true
        case .light: return false
        case .system: return systemScheme == .dark
        }
    }
    
    var body: some View {
        LinearGradient(
            colors: isDark
            ? [
                Color(red: 0.08, green: 0.10, blue: 0.16),
                Color(red: 0.20, green: 0.10, blue: 0.28)
            ]
            : [
                Color(red: 0.35, green: 0.90, blue: 0.88),
                Color(red: 0.76, green: 0.72, blue: 0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    VisitedGradientBackground()
}
