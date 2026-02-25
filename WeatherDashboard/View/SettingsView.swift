//
//  SettingsView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Persisted user preferences
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("appBackground") private var appBackground: AppBackground = .aurora
    @AppStorage("tempUnit") private var tempUnit: TemperatureUnit = .celsius
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Appearance (Light / Dark / System)
                Section("Appearance") {
                    ForEach(AppTheme.allCases) { theme in
                        Button {
                            // Update selected app theme
                            appTheme = theme
                        } label: {
                            HStack {
                                Text(theme.title)
                                Spacer()
                                // Show checkmark for active theme
                                if appTheme == theme {
                                    Image(systemName: "checkmark").foregroundStyle(.blue)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: - Background Style
                Section("Background") {
                    ForEach(AppBackground.allCases) { bg in
                        Button {
                            // Update selected background style
                            appBackground = bg
                        } label: {
                            HStack {
                                Text(bg.title)
                                Spacer()
                                // Show checkmark for active background
                                if appBackground == bg {
                                    Image(systemName: "checkmark").foregroundStyle(.blue)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // MARK: - Temperature Unit (Celsius / Fahrenheit)
                Section("Temperature Unit") {
                    ForEach(TemperatureUnit.allCases) { unit in
                        Button {
                            // Update temperature unit preference
                            tempUnit = unit
                        } label: {
                            HStack {
                                Text(unit.title)
                                Spacer()
                                // Show checkmark for selected unit
                                if tempUnit == unit {
                                    Image(systemName: "checkmark").foregroundStyle(.blue)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
