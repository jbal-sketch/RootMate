//
//  User.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var location: String // For weather API
    var plants: [Plant]
    var notificationTime: Date // Time of day for notifications
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        location: String,
        plants: [Plant] = [],
        notificationTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.location = location
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

