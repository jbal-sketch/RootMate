//
//  PlantViewModel.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation
import SwiftUI

// Message storage for feed
struct PlantMessage: Identifiable, Codable {
    let id: UUID
    let plantId: UUID
    let plantNickname: String
    let plantSpecies: String
    let plantVibe: PlantVibe
    let message: String
    let date: Date
    
    init(id: UUID = UUID(), plantId: UUID, plantNickname: String, plantSpecies: String, plantVibe: PlantVibe, message: String, date: Date = Date()) {
        self.id = id
        self.plantId = plantId
        self.plantNickname = plantNickname
        self.plantSpecies = plantSpecies
        self.plantVibe = plantVibe
        self.message = message
        self.date = date
    }
}

@MainActor
class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var recentMessages: [PlantMessage] = [] // Feed messages
    
    // Current user ID - in production, this would come from authentication
    let currentUserId: UUID
    
    private let weatherService = WeatherService()
    private var aiService: AIService?
    @Published var subscriptionService = SubscriptionService.shared
    
    init(currentUserId: UUID = UUID()) {
        self.currentUserId = currentUserId
        // Load sample data for demo
        loadSamplePlants()
        // Initialize AI service with backend URL
        initializeAIService()
    }
    
    private func initializeAIService() {
        // Use backend URL from APIConfiguration
        let backendURL = APIConfiguration.shared.generateMessageURL.replacingOccurrences(of: "/api/generate-message", with: "")
        aiService = AIService(backendURL: backendURL)
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
                healthStreak: 5
            ),
            Plant(
                userId: currentUserId,
                nickname: "Basil",
                species: "Basil",
                vibe: .chillRoomie,
                status: .hydrated,
                lastWatered: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
                healthStreak: 12
            ),
            Plant(
                userId: currentUserId,
                nickname: "Winston",
                species: "Snake Plant",
                vibe: .grumpySenior,
                status: .hydrated,
                lastWatered: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
                healthStreak: 30
            )
        ]
    }
    
    func addPlant(_ plant: Plant) throws {
        // Check subscription limit
        let maxPlants = subscriptionService.maxPlants
        
        // If not subscribed, check if adding this plant would exceed the limit
        if !subscriptionService.isSubscribed {
            if plants.count >= maxPlants {
                throw PlantError.subscriptionRequired
            }
        } else {
            // Subscribed users can have up to maxPlants
            if plants.count >= maxPlants {
                throw PlantError.plantLimitReached(maxPlants: maxPlants)
            }
        }
        
        // Generate QR code for the plant if it doesn't have one
        var plantWithQR = plant
        if plantWithQR.qrCode == nil {
            // Generate a unique QR code identifier using the plant's UUID
            plantWithQR.qrCode = plant.id.uuidString
        }
        plants.append(plantWithQR)
        
        // Schedule notification for new plant
        scheduleNotificationsForAllPlants()
    }
    
    enum PlantError: LocalizedError {
        case subscriptionRequired
        case plantLimitReached(maxPlants: Int)
        case subscriptionRequiredForDailyUpdates
        
        var errorDescription: String? {
            switch self {
            case .subscriptionRequired:
                return "Subscribe to RootMate Premium to add more than \(SubscriptionService.shared.maxPlants) plants. Get daily updates for up to \(SubscriptionService.shared.maxPlants) plants with a 7-day free trial."
            case .plantLimitReached(let maxPlants):
                return "You've reached the limit of \(maxPlants) plants. Upgrade to add more plants."
            case .subscriptionRequiredForDailyUpdates:
                return "Subscribe to RootMate Premium to get daily AI-powered messages from your plants. Start your 7-day free trial today!"
            }
        }
    }
    
    // Schedule notifications for all plants
    func scheduleNotificationsForAllPlants() {
        if let savedTimeInterval = UserDefaults.standard.object(forKey: "notificationTime") as? TimeInterval {
            let calendar = Calendar.current
            let savedDate = Date(timeIntervalSince1970: savedTimeInterval)
            let hour = calendar.component(.hour, from: savedDate)
            let minute = calendar.component(.minute, from: savedDate)
            let notificationTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
            
            NotificationService.shared.scheduleNotifications(for: plants, at: notificationTime, viewModel: self)
        } else {
            // Default to 9 AM
            let defaultTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            NotificationService.shared.scheduleNotifications(for: plants, at: defaultTime, viewModel: self)
        }
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
        // Check subscription status - daily updates require subscription
        await subscriptionService.checkSubscriptionStatus()
        guard subscriptionService.isSubscribed else {
            throw PlantError.subscriptionRequiredForDailyUpdates
        }
        
        // Check if message already exists for today
        if hasMessageForToday(for: plant.id) {
            if let existingMessage = getTodaysMessage(for: plant.id) {
                return existingMessage.message
            }
        }
        
        // Initialize AI service if not already configured
        if aiService == nil {
            initializeAIService()
        }
        
        guard let aiService = aiService else {
            throw NSError(domain: "PlantViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "AI service not available. Please try again later."])
        }
        
        // Get weather data if user has a location set in settings
        var weatherData: WeatherData? = nil
        if let location = UserDefaults.standard.string(forKey: "userLocation"), !location.isEmpty {
            // Get coordinates for the location, then fetch weather
            do {
                let coordinates = try await weatherService.getCoordinates(for: location)
                weatherData = try await weatherService.fetchWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
            } catch {
                // Continue without weather data if fetch fails
                print("Failed to fetch weather: \(error)")
            }
        }
        
        // Get system prompt for the plant's vibe
        let systemPrompt = AISystemPrompts.getPrompt(for: plant.species, vibe: plant.vibe)
        
        // Generate the message
        let message = try await aiService.generatePlantMessage(
            plant: plant,
            weatherData: weatherData,
            systemPrompt: systemPrompt
        )
        
        // Store message in feed
        let plantMessage = PlantMessage(
            plantId: plant.id,
            plantNickname: plant.nickname,
            plantSpecies: plant.species,
            plantVibe: plant.vibe,
            message: message
        )
        recentMessages.insert(plantMessage, at: 0) // Add to beginning
        // Keep only last 20 messages
        if recentMessages.count > 20 {
            recentMessages = Array(recentMessages.prefix(20))
        }
        
        return message
    }
    
    // Check if a message was already generated today for a plant
    func hasMessageForToday(for plantId: UUID) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return recentMessages.contains { message in
            message.plantId == plantId && calendar.startOfDay(for: message.date) == today
        }
    }
    
    // Get today's message for a plant (if exists)
    func getTodaysMessage(for plantId: UUID) -> PlantMessage? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return recentMessages.first { message in
            message.plantId == plantId && calendar.startOfDay(for: message.date) == today
        }
    }
    
    // Generate daily messages for all plants if it's past notification time
    func generateDailyMessagesIfNeeded() async {
        // Get notification time from UserDefaults
        let calendar = Calendar.current
        let now = Date()
        
        var notificationHour = 9 // Default 9 AM
        var notificationMinute = 0
        
        if let savedTimeInterval = UserDefaults.standard.object(forKey: "notificationTime") as? TimeInterval {
            let savedDate = Date(timeIntervalSince1970: savedTimeInterval)
            notificationHour = calendar.component(.hour, from: savedDate)
            notificationMinute = calendar.component(.minute, from: savedDate)
        }
        
        // Check if it's past notification time today
        guard let notificationTime = calendar.date(bySettingHour: notificationHour, minute: notificationMinute, second: 0, of: now) else {
            return
        }
        
        // Only generate if it's past the notification time
        guard now >= notificationTime else {
            return
        }
        
        // Generate messages for all plants that don't have today's message
        for plant in plants {
            if !hasMessageForToday(for: plant.id) {
                do {
                    _ = try await generateDailyMessage(for: plant)
                } catch {
                    print("Failed to generate message for \(plant.nickname): \(error)")
                }
            }
        }
    }
}

