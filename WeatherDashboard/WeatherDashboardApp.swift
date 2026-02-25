//
//  WeatherDashboardApp.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

@main
struct WeatherDashboardTemplateApp: App {
    
    @StateObject private var vm: MainAppViewModel  // Shared ViewModel instance used across the entire app
    private let container: ModelContainer
    
    init() {
        
        //  Define schema for all models
        let schema = Schema([Place.self, AnnotationModel.self])
        
        //  Persistent (on-disk) configuration
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
        
        //  Create main model context
        let context = ModelContext(container)
        _vm = StateObject(wrappedValue: MainAppViewModel(context: context))
    }
    
    var body: some Scene {
        WindowGroup {
            NavBarView()
                .environmentObject(vm)
                .modelContainer(container)
                .preferredColorScheme(selectedColorScheme)
        }
    }
    
    // Stores the user-selected app theme
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    // Converts the stored theme preference into a SwiftUI ColorScheme
    private var selectedColorScheme: ColorScheme? {
        switch appTheme {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}
