//
//  WeatherService.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

// Responsible for fetching real-time weather data from OpenWeather API Call.
import Foundation

@MainActor
final class WeatherService {
    private let apiKey = "API key" // API key
    
    // Fetches current weather and daily forecast data for a given latitude and longitude.
    // Returns a WeatherResponse model or throws an error if something fails.
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        
        /// Build the API request URL with required query parameters
        var components = URLComponents(string: "https://api.openweathermap.org/data/3.0/onecall")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "exclude", value: "minutely,hourly,alerts"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        /// Ensure the final URL is valid
        guard let url = components?.url else {
            throw WeatherMapError.invalidURL(components?.string ?? "nil")
        }
        
        do {
            /// Perform the network request
            let (data, response) = try await URLSession.shared.data(from: url)
            
            /// Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherMapError.missingData(message: "Response was not HTTPURLResponse")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw WeatherMapError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw WeatherMapError.missingData(message: "Empty response body")
            }
            
            /// Decode JSON response into WeatherResponse model
            do {
                return try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                throw WeatherMapError.decodingError(error)
            }
        } catch let error as WeatherMapError {
            throw error
        } catch {
            throw WeatherMapError.networkError(error)
        }
    }
}
