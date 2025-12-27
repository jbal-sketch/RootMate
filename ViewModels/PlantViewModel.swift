//
//  PlantViewModel.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation
import SwiftUI

@MainActor
class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Current user ID - in production, this would come from authentication
    let currentUserId: UUID
    
    private let weatherService = WeatherService()
    private var aiService: AIService?
    
    init(currentUserId: UUID = UUID()) {
        self.currentUserId = currentUserId
        // Load sample data for demo
        loadSamplePlants()
    }
    
    func configureAI(apiKey: String) {
        aiService = AIService(apiKey: apiKey)
    }
    
    private func loadSamplePlants() {
        plants = [
            Plant(
                userId: currentUserId,
                nickname: "Fiona",
                species: "Fiddle Leaf Fig",
                vibe: .dramaQueen,
                status: .thirsty,
                lastWatered: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
                healthStreak: 5,
                location: "Edinburgh, Scotland"
            ),
            Plant(
                userId: currentUserId,
                nickname: "Basil",
                species: "Basil",
                vibe: .chillRoomie,
                status: .hydrated,
                lastWatered: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                healthStreak: 12,
                location: "Edinburgh, Scotland"
            ),
            Plant(
                userId: currentUserId,
                nickname: "Winston",
                species: "Snake Plant",
                vibe: .grumpySenior,
                status: .hydrated,
                lastWatered: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
                healthStreak: 30,
                location: "Edinburgh, Scotland"
            )
        ]
    }
    
    func addPlant(_ plant: Plant) {
        // Generate QR code for the plant if it doesn't have one
        var plantWithQR = plant
        if plantWithQR.qrCode == nil {
            // Generate a unique QR code identifier using the plant's UUID
            plantWithQR.qrCode = plant.id.uuidString
        }
        plants.append(plantWithQR)
    }
    
    func updatePlantStatus(_ plantId: UUID) {
        if let index = plants.firstIndex(where: { $0.id == plantId }) {
            // Update status based on last watered date
            if let lastWatered = plants[index].lastWatered {
                let daysSince = Calendar.current.dateComponents([.day], from: lastWatered, to: Date()).day ?? 0
                
                if daysSince > 7 {
                    plants[index].status = .critical
                } else if daysSince > 3 {
                    plants[index].status = .thirsty
                } else {
                    plants[index].status = .hydrated
                    plants[index].healthStreak += 1
                }
            }
        }
    }
    
    func waterPlant(_ plantId: UUID) {
        if let index = plants.firstIndex(where: { $0.id == plantId }) {
            plants[index].lastWatered = Date()
            plants[index].status = .hydrated
            plants[index].healthStreak += 1
        }
    }
    
    func getHealthStreak(for plant: Plant) -> Int {
        return plant.healthStreak
    }
    
    func refreshAllStatuses() {
        for plant in plants {
            updatePlantStatus(plant.id)
        }
    }
    
    func updatePlant(_ plantId: UUID, nickname: String, species: String, vibe: PlantVibe) {
        if let index = plants.firstIndex(where: { $0.id == plantId }) {
            plants[index].nickname = nickname
            plants[index].species = species
            plants[index].vibe = vibe
        }
    }
    
    func generateDailyMessage(for plant: Plant) async throws -> String {
        guard let aiService = aiService else {
            throw NSError(domain: "PlantViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "AI service not configured. Please set OpenAI API key in settings."])
        }
        
        // Get weather data if location is available
        var weatherData: WeatherData? = nil
        if let location = plant.location {
            // For testing, we'll use Edinburgh coordinates
            // In production, you'd geocode the location string
            do {
                weatherData = try await weatherService.getWeather(latitude: 55.9533, longitude: -3.1883)
            } catch {
                // Continue without weather data if fetch fails
                print("Failed to fetch weather: \(error)")
            }
        }
        
        // Get system prompt for the plant's vibe
        let systemPrompt = AISystemPrompts.getPrompt(for: plant.species, vibe: plant.vibe)
        
        // Generate the message
        return try await aiService.generatePlantMessage(
            plant: plant,
            weatherData: weatherData,
            systemPrompt: systemPrompt
        )
    }
}

