//
//  FavoritesView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.favorites.isEmpty {
                    ContentUnavailableView(
                        "No favourites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart icon to save places here.")
                    )
                } else {
                    // Main list of favourite places
                    List(vm.favorites) { place in
                        Button {
                            load(place)
                        } label: {
                            FavoritePlaceRow(place: place)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vm.toggleFavorite(place)
                            } label: {
                                Label("Remove", systemImage: "heart.slash")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites ❤️")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .bottomBar) {
                    if !vm.favorites.isEmpty {
                        Button(role: .destructive) {
                            vm.clearAllFavorites()
                        } label: {
                            Label("Clear All", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    // Loads the selected favourite location, switches to "Now", and closes the sheet.
    private func load(_ place: Place) {
        Task {
            await vm.loadLocation(fromPlace: place)
            vm.selectedTab = 0
            dismiss()
        }
    }
}

private struct FavoritePlaceRow: View {
    let place: Place
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .font(.headline)
                .foregroundStyle(.primary.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("Lat: \(place.latitude, specifier: "%.3f"), Lon: \(place.longitude, specifier: "%.3f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    FavoritesView().environmentObject(vm)
}
