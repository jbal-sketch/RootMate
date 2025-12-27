//
//  WeatherService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
    let daily: DailyWeather
    
    struct CurrentWeather: Codable {
        let temperature: Double
        let humidity: Double
        let precipitation: Double
        let weatherCode: Int
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temperature_2m"
            case humidity = "relative_humidity_2m"
            case precipitation
            case weatherCode = "weather_code"
        }
    }
    
    struct DailyWeather: Codable {
        let time: [String]
        let temperatureMax: [Double]
        let precipitationSum: [Double]
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperatureMax = "temperature_2m_max"
            case precipitationSum = "precipitation_sum"
        }
    }
}

struct WeatherResponse: Codable {
    let current: WeatherData.CurrentWeather
    let daily: WeatherData.DailyWeather
}

class WeatherService {
    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "\(baseURL)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,precipitation,weather_code&daily=temperature_2m_max,precipitation_sum&timezone=auto"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return WeatherData(current: response.current, daily: response.daily)
    }
    
    // Simplified geocoding - in production, use a proper geocoding service
    func getCoordinates(for location: String) async throws -> (latitude: Double, longitude: Double) {
        // For demo purposes, return Edinburgh, Scotland coordinates
        // In production, integrate with a geocoding API
        if location.lowercased().contains("scotland") || location.lowercased().contains("edinburgh") {
            return (55.9533, -3.1883) // Edinburgh
        }
        // Default to a common location
        return (40.7128, -74.0060) // New York
    }
}

