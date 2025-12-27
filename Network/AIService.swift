//
//  AIService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

// Backend API Request/Response structures
struct BackendRequest: Codable {
    let plant: PlantData
    let weatherData: WeatherData?
    let systemPrompt: String
    
    struct PlantData: Codable {
        let nickname: String
        let species: String
        let vibe: String
        let status: String
        let healthStreak: Int
        let lastWatered: String? // ISO date string
    }
    
    struct WeatherData: Codable {
        let current: CurrentWeather
        
        struct CurrentWeather: Codable {
            let temperature: Double
            let humidity: Double
            let precipitation: Double
        }
    }
}

struct BackendResponse: Codable {
    let message: String
    let error: String?
}

class AIService {
    // Backend API endpoint URL
    private let baseURL: String
    
    init(backendURL: String? = nil) {
        // Use provided URL or get from APIConfiguration
        if let customURL = backendURL {
            self.baseURL = customURL.hasSuffix("/api/generate-message") ? customURL : "\(customURL)/api/generate-message"
        } else {
            self.baseURL = APIConfiguration.shared.generateMessageURL
        }
    }
    
    func generatePlantMessage(
        plant: Plant,
        weatherData: WeatherData?,
        systemPrompt: String
    ) async throws -> String {
        // Prepare plant data for backend
        let dateFormatter = ISO8601DateFormatter()
        let lastWateredString = plant.lastWatered.map { dateFormatter.string(from: $0) }
        
        let plantData = BackendRequest.PlantData(
            nickname: plant.nickname,
            species: plant.species,
            vibe: plant.vibe.rawValue,
            status: plant.status.rawValue,
            healthStreak: plant.healthStreak,
            lastWatered: lastWateredString
        )
        
        // Prepare weather data if available
        let backendWeatherData: BackendRequest.WeatherData?
        if let weather = weatherData {
            backendWeatherData = BackendRequest.WeatherData(
                current: BackendRequest.WeatherData.CurrentWeather(
                    temperature: weather.current.temperature,
                    humidity: weather.current.humidity,
                    precipitation: weather.current.precipitation
                )
            )
        } else {
            backendWeatherData = nil
        }
        
        // Create request body
        let requestBody = BackendRequest(
            plant: plantData,
            weatherData: backendWeatherData,
            systemPrompt: systemPrompt
        )
        
        // Create URL request
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(requestBody)
        
        // Make request to backend
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check for HTTP errors
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            // Try to parse error response
            if let errorData = try? JSONDecoder().decode(BackendResponse.self, from: data),
               let errorMessage = errorData.error {
                print("Backend API Error: \(errorMessage)")
                throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            } else if let errorString = String(data: data, encoding: .utf8) {
                print("Backend API Error Response: \(errorString)")
                throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed: \(errorString)"])
            }
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Backend API HTTP Error \(httpResponse.statusCode): \(errorString)")
            throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed with status \(httpResponse.statusCode): \(errorString)"])
        }
        
        // Parse response
        let backendResponse = try JSONDecoder().decode(BackendResponse.self, from: data)
        
        // Return message or fallback
        return backendResponse.message.isEmpty ? "I'm doing great! 🌿" : backendResponse.message
    }
}

