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
    var systemInstruction: SystemInstruction?
    var generationConfig: GenerationConfig?
    
    enum CodingKeys: String, CodingKey {
        case contents
        case systemInstruction
        case generationConfig
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contents, forKey: .contents)
        // Only encode systemInstruction if it's not nil
        if let systemInstruction = systemInstruction {
            try container.encode(systemInstruction, forKey: .systemInstruction)
        }
        // Only encode generationConfig if it's not nil
        if let generationConfig = generationConfig {
            try container.encode(generationConfig, forKey: .generationConfig)
        }
    }
    
    struct Content: Codable {
        let parts: [Part]
        
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
    private let model = "gemini-2.5-flash-lite" // Gemini 2.5 Flash-Lite
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
        
        // Combine system prompt with user prompt (some API versions don't support systemInstruction)
        let fullPrompt = "\(systemPrompt)\n\n\(userPrompt)"
        
        var request = GeminiRequest(
            contents: [
                GeminiRequest.Content(
                    parts: [GeminiRequest.Content.Part(text: fullPrompt)]
                )
            ],
            systemInstruction: nil,
            generationConfig: GeminiRequest.GenerationConfig(temperature: 0.8)
        )
        
        // Gemini API endpoint format: /v1/models/{model}:generateContent?key={apiKey}
        // URL encode the API key to handle special characters
        guard let encodedApiKey = apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/\(model):generateContent?key=\(encodedApiKey)") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check for HTTP errors
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            // Try to parse error response
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let error = errorData["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("Gemini API Error: \(message)")
                    throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                } else if let errorString = String(data: data, encoding: .utf8) {
                    print("Gemini API Error Response: \(errorString)")
                    throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed: \(errorString)"])
                }
            }
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Gemini API HTTP Error \(httpResponse.statusCode): \(errorString)")
            throw NSError(domain: "AIService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API request failed with status \(httpResponse.statusCode): \(errorString)"])
        }
        
        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        return geminiResponse.candidates.first?.content.parts.first?.text ?? "I'm doing great! 🌿"
    }
}

