//
//  VisitedPlacesView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

struct VisitedPlacesView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var showLoadedAlert = false
    @State private var loadedPlaceName = ""
    
    var body: some View {
        ZStack {
            VisitedGradientBackground()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Visited Places 📍")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary.opacity(0.75))
                    .padding(18)
                
                List {
                    if vm.visited.isEmpty {
                        Text("No places visited yet.")
                            .foregroundColor(.secondary)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(vm.visited) { place in
                            VisitedPlaceRow(
                                place: place,
                                isSelected: place.name == vm.activePlaceName,
                                onTap: {
                                    // Loads a saved place
                                    Task {
                                        await vm.loadLocation(fromPlace: place)
                                        loadedPlaceName = place.name
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                            showLoadedAlert = true
                                        }
                                    }
                                },
                                onToggleFavorite: {
                                    vm.toggleFavorite(place)
                                }
                            )
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deletePlaces)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .alert("Place Loaded", isPresented: $showLoadedAlert) {
            Button("OK") { vm.selectedTab = 0 } // switch to Now Tab
        } message: {
            Text("\(loadedPlaceName) loaded successfully.")
        }
    }
    
    // Deletes selected rows
    private func deletePlaces(at offsets: IndexSet) {
        offsets.map { vm.visited[$0] }
            .forEach { vm.delete(place: $0) }
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    VisitedPlacesView()
        .environmentObject(vm)
}
