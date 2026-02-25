//
//  VisitedRowPressedStyle.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct VisitedRowPressedStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? Color.blue.opacity(0.18) : Color.clear)
            )
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
