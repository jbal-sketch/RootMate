//
//  AIService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

// Gemini API Request/Response structures
struct GeminiRequest: Codable {
    let contents: [Content]
    let systemInstruction: SystemInstruction?
    let generationConfig: GenerationConfig
    
    struct Content: Codable {
        let parts: [Part]
        let role: String?
        
        struct Part: Codable {
            let text: String
        }
    }
    
    struct SystemInstruction: Codable {
        let parts: [Part]
        
        struct Part: Codable {
            let text: String
        }
    }
    
    struct GenerationConfig: Codable {
        let temperature: Double
    }
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: Content
        
        struct Content: Codable {
            let parts: [Part]
            
            struct Part: Codable {
                let text: String
            }
        }
    }
}

class AIService {
    private let apiKey: String
    private let model = "gemini-1.5-flash" // or "gemini-1.5-pro" for better quality
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models"
    
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
        
        // Combine system prompt with user prompt for Gemini
        // Gemini doesn't have separate system messages, so we'll include it in the prompt
        let fullPrompt = "\(systemPrompt)\n\n\(userPrompt)"
        
        let request = GeminiRequest(
            contents: [
                GeminiRequest.Content(
                    parts: [GeminiRequest.Content.Part(text: fullPrompt)],
                    role: "user"
                )
            ],
            systemInstruction: nil, // We're including system prompt in the message instead
            generationConfig: GeminiRequest.GenerationConfig(temperature: 0.8)
        )
        
        // Gemini API endpoint format: /v1beta/models/{model}:generateContent?key={apiKey}
        guard let url = URL(string: "\(baseURL)/\(model):generateContent?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check for HTTP errors
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorData["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            }
            throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }
        
        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        return geminiResponse.candidates.first?.content.parts.first?.text ?? "I'm doing great! 🌿"
    }
}

