//
//  NavBarView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

struct NavBarView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @State private var showSettings = false
    @State private var showFavorites = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            // Top-right action buttons (Favorites + Settings)
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    Spacer()
                    
                    // Opens Favorites list
                    Button {
                        showFavorites = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    // Opens Settings
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                
                // Search Bar: user types a location and triggers vm.submitQuery()
                HStack {
                    Text("Change Location")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    TextField("Enter New Location", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit { vm.submitQuery() }
                    
                    Button {
                        vm.submitQuery()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2).foregroundColor(.primary)
                    }
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 3, y: 2)
                .padding(.horizontal)
                
                Spacer().frame(height: 10)
                
                // Tabs
                TabView(selection: $vm.selectedTab) {
                    CurrentWeatherView()
                        .tabItem { Label("Now", systemImage: "sun.max.fill") }
                        .tag(0)
                    
                    ForecastView()
                        .tabItem { Label("Forecast", systemImage: "calendar") }
                        .tag(1)
                    
                    MapView()
                        .tabItem { Label("Map", systemImage: "map") }
                        .tag(2)
                    
                    VisitedPlacesView()
                        .tabItem { Label("Saved", systemImage: "globe") }
                        .tag(3)
                }
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
            
            .overlay {
                if vm.isLoading {
                    ProgressView("Loading…")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert(vm.statusTitle, isPresented: $vm.showStatusAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.statusMessage)
        }
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    NavBarView()
        .environmentObject(vm)
}
