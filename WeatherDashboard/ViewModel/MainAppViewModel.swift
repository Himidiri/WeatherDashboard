//
//  MainAppViewModel.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData
import MapKit
internal import Combine

// Used to tell the UI whether a location was loaded from storage or newly saved.
enum LocationLoadResult {
    case loadedFromStorage(String)
    case savedNew(String)
}

@MainActor
final class MainAppViewModel: ObservableObject {
    @Published var query = ""
    @Published var selectedTab: Int = 0
    @Published var isLoading = false
    @Published var showStatusAlert = false
    @Published var statusTitle = "Alert"
    @Published var statusMessage = ""
    @Published var weatherResponse: WeatherResponse?
    @Published var currentWeather: Weather?
    @Published var forecast: [Weather] = []
    @Published var activePlaceName: String = ""
    private let defaultPlaceName = "London"
    @Published var pois: [AnnotationModel] = []       // POIs for Map and list
    @Published var mapRegion = MKCoordinateRegion()   // region used by older map code
    @Published var mapOverviewRegion: MKCoordinateRegion?
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var visited: [Place] = []              // saved/search history
    @Published var appError: WeatherMapError?
    private let weatherService = WeatherService()     // fetches OpenWeather data
    private let locationManager = LocationManager()   // geocoding + POI search
    private let context: ModelContext                // Use a context to manage database operations
    
    init(context: ModelContext) {
        self.context = context
        
        // Load stored places.
        if let results = try? context.fetch(
            FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
        ) {
            self.visited = results
        }
        
        // Load default location.
        Task { await loadDefaultLocation() }
    }
    
    // MARK: - Search
    
    func submitQuery() {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !city.isEmpty else {
            query = ""
            showAlert(title: "Error", "Please type a location before searching.")
            return
        }
        
        Task {
            do {
                let result = try await loadLocation(byName: city)
                query = ""
                
                switch result {
                case .loadedFromStorage(let name):
                    showAlert("Loaded from storage: \(name)")
                    
                case .savedNew(let name):
                    showAlert("Fetched and Saved: \(name)")
                }
                
            } catch {
                query = ""
                
                if let err = error as? WeatherMapError {
                    showAlert(title: "Error", err.localizedDescription)
                } else {
                    showAlert(title: "Error", "Invalid location. Reverting to London.")
                }
            }
        }
    }
    
    // Loads the default location London.
    func loadDefaultLocation() async {
        do {
            _ = try await loadLocation(byName: defaultPlaceName, showUserAlerts: false)
        } catch {
            appError = (error as? WeatherMapError) ?? .networkError(error)
        }
    }
    
    func search() async throws {
        let city = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else { return }
        _ = try await loadLocation(byName: city)
    }
    
    // MARK: - Load Location Logic
    
    // Loads a location by name:
    /// - If saved already: loads name+POIs from DB, fetches fresh weather, returns .loadedFromStorage
    /// - If new: fetches weather+POIs, save name+POI to DB, returns .savedNew
    /// - If invalid: throws and caller reverts to London
    func loadLocation(byName: String, showUserAlerts: Bool = true) async throws -> LocationLoadResult {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Convert city name -> coordinates
            let geo = try await locationManager.geocodeAddress(byName)
            
            // If already in DB, reuse it (no duplicates).
            if let existing = fetchPlaceByName(geo.name) {
                try await loadAll(for: existing)
                
                existing.lastUsedAt = .now
                try? context.save()
                
                refreshVisited()
                
                return .loadedFromStorage(existing.name)
            }
            
            // Fetch weather + POIs for new place.
            let response = try await weatherService.fetchWeather(lat: geo.lat, lon: geo.lon)
            weatherResponse = response
            let foundPOIs = try await locationManager.findPOIs(lat: geo.lat, lon: geo.lon, limit: 5)
            
            // Save the new place and its POIs.
            let newPlace = Place(name: geo.name, latitude: geo.lat, longitude: geo.lon)
            foundPOIs.forEach { $0.place = newPlace }
            newPlace.pois = foundPOIs
            
            context.insert(newPlace)
            try context.save()
            
            // Update UI state.
            activePlaceName = newPlace.name
            pois = foundPOIs
            updateOverviewRegionFromPOIs()
            resetMapToOverviewIfAvailable()
            
            currentWeather = response.current.weather.first
            forecast = response.daily.compactMap { $0.weather.first }
            
            refreshVisited()
            
            return .savedNew(newPlace.name)
            
        } catch {
            weatherResponse = nil
            
            // If user typed invalid location, revert to London
            if showUserAlerts {
                showAlert(title: "Error", "Invalid location. Reverting to London.")
                await loadDefaultLocation()
            }
            
            throw (error as? WeatherMapError) ?? WeatherMapError.networkError(error)
        }
    }
    
    // Loads a location from an already saved Place row (Visited).
    func loadLocation(fromPlace place: Place) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await loadAll(for: place)
            
            place.lastUsedAt = .now
            try? context.save()
            refreshVisited()
            
        } catch let err as WeatherMapError {
            appError = err
        } catch {
            appError = .networkError(error)
        }
    }
    
    // Loads weather + POIs for a saved place and refreshes map + UI state.
    private func loadAll(for place: Place) async throws {
        activePlaceName = place.name
        
        let response = try await weatherService.fetchWeather(lat: place.latitude, lon: place.longitude)
        
        weatherResponse = response
        currentWeather = response.current.weather.first
        forecast = response.daily.compactMap { $0.weather.first }
        
        // If POIs were not stored, fetch them once and save.
        if place.pois.isEmpty {
            let fetched = try await locationManager.findPOIs(lat: place.latitude, lon: place.longitude, limit: 5)
            fetched.forEach { $0.place = place }
            place.pois = fetched
            try? context.save()
            pois = fetched
        } else {
            pois = place.pois
        }
        
        updateOverviewRegionFromPOIs()
        resetMapToOverviewIfAvailable()
        
        refreshVisited()
    }
    
    // MARK: - Map Helpers
    
    // Keeps map zoomed out to include all POIs.
    func resetMapToOverviewIfAvailable() {
        if mapOverviewRegion == nil {
            updateOverviewRegionFromPOIs()
        }
        if let overview = mapOverviewRegion {
            mapRegion = overview
            cameraPosition = .region(overview)
        }
    }
    
    // Builds an overview region from the current POI coordinates.
    func updateOverviewRegionFromPOIs() {
        let coords = pois.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        guard !coords.isEmpty else { return }
        
        var region = MKCoordinateRegion.fit(coordinates: coords)
        region.span.latitudeDelta *= 1.35
        region.span.longitudeDelta *= 1.35
        
        mapOverviewRegion = region
    }
    
    // Zoom helper used when user selects a coordinate.
    func focus(on coordinate: CLLocationCoordinate2D, zoom: Double = 0.02) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: zoom,
                longitudeDelta: zoom
            )
        )
        cameraPosition = .region(region)
    }
    
    // Zoom helper for POI selection.
    func focusOnPOI(_ coordinate: CLLocationCoordinate2D) {
        withAnimation {
            let region = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            cameraPosition = .region(region)
        }
    }
    
    // MARK: - SwiftData Helpers
    
    // Deletes a saved place from SwiftData.
    func delete(place: Place) {
        context.delete(place)
        do { try context.save() } catch { }
        refreshVisited()
    }
    
    // Finds a Place in SwiftData by name (case-insensitive).
    private func fetchPlaceByName(_ name: String) -> Place? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        if let all = try? context.fetch(FetchDescriptor<Place>()) {
            return all.first {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmed.lowercased()
            }
        }
        return nil
    }
    
    // Reloads visited places from SwiftData (keeps UI in sync).
    private func refreshVisited() {
        if let results = try? context.fetch(
            FetchDescriptor<Place>(sortBy: [SortDescriptor(\Place.lastUsedAt, order: .reverse)])
        ) {
            visited = results
        }
    }
    
    private func showAlert(title: String = "Alert", _ message: String) {
        statusTitle = title
        statusMessage = message
        showStatusAlert = true
    }
    
    // MARK: - Favorites

        // Returns only places marked as favorite.
    var favorites: [Place] {
        visited.filter { $0.isFavorite }
    }
    
    // Toggles a place as favorite/unfavorite and saves the change.
    func toggleFavorite(_ place: Place) {
        place.isFavorite.toggle()
        try? context.save()
        refreshVisited()
    }
    
    // Toggles favorite for the currently active place.
    func toggleFavoriteForActivePlace() {
        let name = activePlaceName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        guard let p = fetchPlaceByName(name) else { return }   // only already saved places
        toggleFavorite(p)
    }
    
    // clear all favorites at once
    func clearAllFavorites() {
        visited.forEach { $0.isFavorite = false }
        try? context.save()
        refreshVisited()
    }
}
