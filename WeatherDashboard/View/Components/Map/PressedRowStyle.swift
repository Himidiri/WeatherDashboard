//
//  PressedRowStyle.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct PressedRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(configuration.isPressed ? Color.white.opacity(0.18) : Color.clear)
            )
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
