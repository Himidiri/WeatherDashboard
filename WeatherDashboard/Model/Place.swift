//
//  Place.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftData
import CoreLocation

// MARK: - Place Model
// Represents a saved location searched by the user.
@Model
final class Place {
    @Attribute(.unique) var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var lastUsedAt: Date
    var isFavorite: Bool
    
    /// One-to-many relationship: a place can have multiple POIs
    /// Cascade delete ensures POIs are removed when the place is deleted
    @Relationship(deleteRule: .cascade, inverse: \AnnotationModel.place)
    var pois: [AnnotationModel] = []
    
    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        lastUsedAt: Date = .now,
        pois: [AnnotationModel] = [],
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.lastUsedAt = lastUsedAt
        self.pois = pois
        self.isFavorite = isFavorite
    }
}

// MARK: - AnnotationModel
// Represents a tourist attraction (POI) shown on the map.
@Model
final class AnnotationModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var place: Place?   // Reference to the parent Place
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double,place: Place? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.place = place
    }
}
