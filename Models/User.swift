//
//  User.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

enum SubscriptionTier: String, Codable {
    case sprout = "Sprout" // $0
    case flourish = "Flourish" // $4.99/mo
    case jungle = "Jungle" // $12.99/mo
    
    var price: Double {
        switch self {
        case .sprout:
            return 0.0
        case .flourish:
            return 4.99
        case .jungle:
            return 12.99
        }
    }
    
    var features: [String] {
        switch self {
        case .sprout:
            return ["1 plant", "Basic updates", "Email notifications"]
        case .flourish:
            return ["5 plants", "AI personality updates", "Email + SMS", "Weather sync"]
        case .jungle:
            return ["Unlimited plants", "All AI features", "Photo verification", "Priority support", "Advanced analytics"]
        }
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var location: String // For weather API
    var subscriptionTier: SubscriptionTier
    var plants: [Plant]
    var notificationTime: Date // Time of day for notifications
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        location: String,
        subscriptionTier: SubscriptionTier = .sprout,
        plants: [Plant] = [],
        notificationTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.location = location
        self.subscriptionTier = subscriptionTier
        self.plants = plants
        self.notificationTime = notificationTime
    }
}

struct MemorySnippet: Identifiable, Codable {
    let id: UUID
    let plantId: UUID
    let timestamp: Date
    let content: String // AI-generated memory/story snippet
    
    init(id: UUID = UUID(), plantId: UUID, timestamp: Date = Date(), content: String) {
        self.id = id
        self.plantId = plantId
        self.timestamp = timestamp
        self.content = content
    }
}

