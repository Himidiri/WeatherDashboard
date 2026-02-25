//
//  DetailRow.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.blue.opacity(0.85))
                .frame(width: 22)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .fontWeight(.semibold)

            Spacer()

            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
                .fontWeight(.semibold)
        }
    }
}

