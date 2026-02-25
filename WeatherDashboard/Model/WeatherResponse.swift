//
//  WeatherResponse.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

//  Data models used to decode the OpenWeather One Call API response.
import Foundation

// MARK: - WeatherResponse
// Root response object returned by the OpenWeather API.
struct WeatherResponse: Codable {
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case daily
    }
}

// MARK: - Current Weather
// Represents current weather details.
struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let pressure: Int
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case pressure
        case weather
    }
}

// MARK: - Daily Forecast
// Represents one day in the forecast.
struct Daily: Codable {
    let dt: Int
    let summary: String
    let temp: Temp
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case summary
        case temp
        case weather
    }
}

// MARK: - Temperature
// Holds daily minimum and maximum temperatures.
struct Temp: Codable {
    let min: Double
    let max: Double
    
    enum CodingKeys: String, CodingKey {
        case min
        case max
    }
}

// MARK: - Weather Description
// Describes the weather condition and associated icon.
struct Weather: Codable {
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}
