//
//  MapView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 0) {
            mapSection
                .frame(height: 320)
                .frame(maxWidth: .infinity)
                .background(Color.black)
            
            titleBar
            
            listBackgroundSection
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
        }
        // When tab appears, zoom out to show all POIs.
        .onAppear {
            vm.resetMapToOverviewIfAvailable()
        }
    }
    
    // Top map area with pins for each POI.
    private var mapSection: some View {
        Map(position: $vm.cameraPosition) {
            ForEach(vm.pois.prefix(5)) { poi in
                Annotation(
                    poi.name,
                    coordinate: CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
                ) {
                    // Tap pin -> zoom to a 500m region around it.
                    Button { zoomToPOI(poi) } label: {
                        MapPOIPinView()
                    }
                    .buttonStyle(.plain)
                    // Long press pin -> open Google search for the place name.
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                openGoogleSearch(poi.name)
                            }
                    )
                }
            }
        }
        .mapStyle(.standard)
        .clipped()
    }
    
    // Small title under the map.
    private var titleBar: some View {
        Text("Top 5 Tourist Attractions in \(vm.activePlaceName.isEmpty ? "Selected Place" : vm.activePlaceName)")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.blue.opacity(0.55))
    }
    
    // POI list content.
    private var poiListSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            if vm.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Loading places...")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.9))
                }
            } else if vm.pois.isEmpty {
                Text("No tourist attractions found for this location.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
            } else {
                // Tap row -> center/zoom map on that POI.
                ForEach(vm.pois.prefix(5)) { poi in
                    POIListRow(title: poi.name) {
                        zoomToPOI(poi)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 18)
        .padding(.top, 35)
        .padding(.bottom, 20)
    }
    
    // Background image + scrollable list.
    private var listBackgroundSection: some View {
        GeometryReader { geo in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                Color.black.opacity(0.25)
                
                ScrollView{
                    poiListSection
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // Zoom helper: focuses map camera around selected POI (500m region).
    private func zoomToPOI(_ poi: AnnotationModel) {
        vm.focusOnPOI(
            CLLocationCoordinate2D(
                latitude: poi.latitude,
                longitude: poi.longitude
            )
        )
    }
    
    // Opens Google search in the default browser.
    private func openGoogleSearch(_ query: String) {
        guard let url = GoogleSearch.url(for: query) else { return }
        openURL(url)
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    MapView()
        .environmentObject(vm)
}
