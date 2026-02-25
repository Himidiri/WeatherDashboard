//
//  POIListRow.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct POIListRow: View {
    let title: String
    let onTap: () -> Void
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.orange)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
            }
        }
        .buttonStyle(PressedRowStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    openGoogleSearch(title)
                }
        )
    }
    
    private func openGoogleSearch(_ query: String) {
        guard let url = GoogleSearch.url(for: query) else { return }
        openURL(url)
    }
}

#Preview {
    POIListRow(title: "Test") {
        print("Tapped")
    }
}
