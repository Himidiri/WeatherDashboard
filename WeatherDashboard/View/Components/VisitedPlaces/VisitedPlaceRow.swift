//
//  VisitedPlaceRow.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

struct VisitedPlaceRow: View {
    let place: Place
    let isSelected: Bool
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary.opacity(0.85))
                    
                    Text("Lat: \(place.latitude, specifier: "%.3f"), Lon: \(place.longitude, specifier: "%.3f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(DateFormatterUtils.formattedVisitedPlaceDateTime(from: place.lastUsedAt.timeIntervalSince1970))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onToggleFavorite) {
                    Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(place.isFavorite ? .red : .primary.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
        }
        .buttonStyle(VisitedRowPressedStyle())
        // Long press opens Google search
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    openGoogleSearch(place.name)
                }
        )
    }
    
    private func openGoogleSearch(_ query: String) {
        guard let url = GoogleSearch.url(for: query) else { return }
        openURL(url)
    }
}
