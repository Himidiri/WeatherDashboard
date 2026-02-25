//
//  LocationManager.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

// Converts user entered place names into coordinates and finds nearby POIs using MapKit.
import Foundation
import CoreLocation
@preconcurrency import MapKit

@MainActor
final class LocationManager {
    
    // Converts a user entered location name into latitude and longitude.
    // Uses Apple’s CLGeocoder and returns the resolved place name with coordinates.
    // Throws an error if the location cannot be found.
    func geocodeAddress(_ address: String) async throws -> (name: String, lat: Double, lon: Double) {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            
            guard
                let placemark = placemarks.first,
                let location = placemark.location
            else {
                throw WeatherMapError.geocodingFailed(address)
            }
            
            /// Use city name if available, otherwise fall back to the searched text
            let resolvedName =
            placemark.locality ??
            placemark.name ??
            address
            
            return (name: resolvedName, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            
        } catch {
            throw WeatherMapError.geocodingFailed(address)
        }
    }
    
    // Find nearby tourist attractions around a coordinate using MKLocalSearch.
    // Maps results into AnnotationModel and returns only the first "limit" items.
    func findPOIs(lat: Double, lon: Double, limit: Int = 5) async throws -> [AnnotationModel] {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Tourist Attractions"
        request.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 2500,
            longitudinalMeters: 2500
        )
        
        let search = MKLocalSearch(request: request)
        
        do {
            let response = try await search.start()
            
            let models: [AnnotationModel] = response.mapItems.compactMap { item in
                guard let name = item.name else { return nil }
                let c = item.placemark.coordinate
                return AnnotationModel(name: name, latitude: c.latitude, longitude: c.longitude)
            }
            
            return Array(models.prefix(limit))
        } catch {
            throw WeatherMapError.networkError(error)
        }
    }
}
