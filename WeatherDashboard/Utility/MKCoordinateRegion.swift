//
//  MKCoordinateRegion.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import MapKit

// Helper to build a map region that fits a set of coordinates.
// Used to zoom out so all POIs are visible at once.
extension MKCoordinateRegion {
    static func fit(coordinates: [CLLocationCoordinate2D], paddingFactor: Double = 1.35) -> MKCoordinateRegion {
        guard let first = coordinates.first else {
            // Fallback region (London) when there are no coordinates.
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }

        var minLat = first.latitude
        var maxLat = first.latitude
        var minLon = first.longitude
        var maxLon = first.longitude

        for c in coordinates {
            minLat = min(minLat, c.latitude)
            maxLat = max(maxLat, c.latitude)
            minLon = min(minLon, c.longitude)
            maxLon = max(maxLon, c.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        var latDelta = (maxLat - minLat) * paddingFactor
        var lonDelta = (maxLon - minLon) * paddingFactor

        latDelta = max(latDelta, 0.01)
        lonDelta = max(lonDelta, 0.01)

        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
    }
}
