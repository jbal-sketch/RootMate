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
    
    private let weatherService = WeatherService()
    private var aiService: AIService?
    
    init() {
        // Load sample data for demo
        loadSamplePlants()
    }
    
    func configureAI(apiKey: String) {
        aiService = AIService(apiKey: apiKey)
    }
    
    private func loadSamplePlants() {
        plants = [
            Plant(
                nickname: "Fiona",
                species: "Fiddle Leaf Fig",
                vibe: .dramaQueen,
                status: .thirsty,
                lastWatered: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
                healthStreak: 5,
                location: "Edinburgh, Scotland"
            ),
            Plant(
                nickname: "Basil",
                species: "Basil",
                vibe: .chillRoomie,
                status: .hydrated,
                lastWatered: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                healthStreak: 12,
                location: "Edinburgh, Scotland"
            ),
            Plant(
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
        plants.append(plant)
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
}

