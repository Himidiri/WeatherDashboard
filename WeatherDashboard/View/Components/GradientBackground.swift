//
//  GradientBackground.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct GradientBackground: View {
    @AppStorage("appBackground") private var appBackground: AppBackground = .aurora
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors(for: appBackground)),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
    
    private func colors(for bg: AppBackground) -> [Color] {
        switch bg {
        case .aurora:
            return [.blue.opacity(0.40), .purple.opacity(0.30), .pink.opacity(0.30)]
        case .sunset:
            return [.orange.opacity(0.40), .pink.opacity(0.35), .purple.opacity(0.30)]
        case .ocean:
            return [.cyan.opacity(0.40), .blue.opacity(0.35), .indigo.opacity(0.30)]
        case .midnight:
            return [.black.opacity(0.70), .indigo.opacity(0.45), .purple.opacity(0.35)]
        }
    }
}

#Preview {
    GradientBackground()
}
