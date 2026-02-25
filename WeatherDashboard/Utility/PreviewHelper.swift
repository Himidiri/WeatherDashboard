//
//  PreviewHelper.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation
import SwiftData

extension ModelContainer {
    
    // Preview-only container (no disk persistence).
    static var preview: ModelContainer {
        do {
            let schema = Schema([Place.self, AnnotationModel.self])
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}
