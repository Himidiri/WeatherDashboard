//
//  CurrentWeatherView.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import SwiftUI
import SwiftData

struct CurrentWeatherView: View {
    @EnvironmentObject var vm: MainAppViewModel
    @AppStorage("tempUnit") private var tempUnit: TemperatureUnit = .celsius
    
    var body: some View {
        ZStack {
            GradientBackground()  // Gradient background
            
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 20) {
                        Text(vm.activePlaceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "London" : vm.activePlaceName)
                            .font(.largeTitle)
                            .bold()
                        
                        // Marks the place as favorite.
                        Button {
                            vm.toggleFavoriteForActivePlace()
                        } label: {
                            Image(systemName: isActivePlaceFavorite ? "heart.fill" : "heart")
                                .foregroundStyle(isActivePlaceFavorite ? .red : .primary)
                        }
                        Spacer()
                        
                        Text(
                            DateFormatterUtils.formattedDate(
                                from: vm.weatherResponse?.current.dt ?? Int(Date().timeIntervalSince1970),
                                format: "EEEE, MMM d"
                            )
                        )
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        // Big temperature + icon.
                        HStack {
                            Text(TemperatureFormatter.intString(fromCelsius: vm.weatherResponse?.current.temp ?? 0, unit: tempUnit)).font(.system(size: 55, weight: .bold))
                            
                            Spacer()
                            
                            Image(systemName: adviceCategory.icon)
                                .font(.system(size: 45))
                                .foregroundColor(.primary)
                        }
                        
                        // Weather condition text (from API).
                        Text(conditionText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary.opacity(0.75))
                        
                        HStack(spacing: 18) {
                            Label(TemperatureFormatter.intString(fromCelsius: vm.weatherResponse?.daily.first?.temp.max ?? 0, unit: tempUnit),
                                  systemImage: "arrow.up")
                            
                            Label(TemperatureFormatter.intString(fromCelsius: vm.weatherResponse?.daily.first?.temp.min ?? 0, unit: tempUnit),
                                  systemImage: "arrow.down")
                            
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        
                        Divider().padding(.top, 6).padding(.bottom, 6)
                        
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Details")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary.opacity(0.35))
                            
                            DetailRow(icon: "gauge", title: "Pressure", value: "\(pressure) hPa")
                            DetailRow(icon: "sunrise.fill", title: "Sunrise", value: sunriseTime)
                            DetailRow(icon: "sunset.fill", title: "Sunset", value: sunsetTime)
                        }
                        
                        Divider().padding(.top, 6).padding(.bottom, 5)
                        
                        // Advisory message from WeatherAdviceCategory.
                        HStack(spacing: 12) {
                            Image(systemName: adviceCategory.icon)
                                .font(.system(size: 34, weight: .semibold))
                                .foregroundColor(adviceCategory.color)
                            
                            Text(adviceCategory.adviceText)
                                .font(.headline)
                                .foregroundColor(.primary.opacity(0.7))
                                .fontWeight(.semibold)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(adviceCategory.color.opacity(0.10))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - Helpers
private extension CurrentWeatherView {
    var currentTempC: Double { vm.weatherResponse?.current.temp ?? 0 }
    var maxTempC: Double { vm.weatherResponse?.daily.first?.temp.max ?? 0 }
    var minTempC: Double { vm.weatherResponse?.daily.first?.temp.min ?? 0 }
    
    var conditionText: String {
        (vm.weatherResponse?.current.weather.first?.description ?? "—").capitalized
    }
    
    var pressure: Int { vm.weatherResponse?.current.pressure ?? 0 }
    
    var sunriseTime: String {
        DateFormatterUtils.formattedTime24HHmm(from: vm.weatherResponse?.current.sunrise ?? 0)
    }
    
    var sunsetTime: String {
        DateFormatterUtils.formattedTime24HHmm(from: vm.weatherResponse?.current.sunset ?? 0)
    }
    
    var adviceCategory: WeatherAdviceCategory {
        WeatherAdviceCategory.from(temp: currentTempC)
    }
    
    var isActivePlaceFavorite: Bool {
        let name = vm.activePlaceName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return false }
        return vm.visited.first(where: { $0.name.lowercased() == name.lowercased() })?.isFavorite ?? false
    }
}

#Preview {
    let vm = MainAppViewModel(context: ModelContext(ModelContainer.preview))
    CurrentWeatherView()
        .environmentObject(vm)
}
