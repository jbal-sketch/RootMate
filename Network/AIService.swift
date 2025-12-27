//
//  AIService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

struct AIMessageRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

struct AIMessageResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}

class AIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generatePlantMessage(
        plant: Plant,
        weatherData: WeatherData?,
        systemPrompt: String
    ) async throws -> String {
        var userPrompt = "Generate a message from \(plant.nickname), a \(plant.species) with a \(plant.vibe.rawValue) vibe."
        
        if let weather = weatherData {
            userPrompt += " Current weather: \(weather.current.temperature)°C, \(weather.current.humidity)% humidity, \(weather.current.precipitation)mm precipitation."
        }
        
        userPrompt += " Plant status: \(plant.status.rawValue). Health streak: \(plant.healthStreak) days."
        
        if let lastWatered = plant.lastWatered {
            let daysSince = Calendar.current.dateComponents([.day], from: lastWatered, to: Date()).day ?? 0
            userPrompt += " Last watered: \(daysSince) days ago."
        }
        
        let request = AIMessageRequest(
            model: "gpt-4o",
            messages: [
                AIMessageRequest.Message(role: "system", content: systemPrompt),
                AIMessageRequest.Message(role: "user", content: userPrompt)
            ],
            temperature: 0.8
        )
        
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(AIMessageResponse.self, from: data)
        
        return response.choices.first?.message.content ?? "I'm doing great! 🌿"
    }
}

