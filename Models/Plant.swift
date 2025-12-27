//
//  Plant.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation

enum PlantVibe: String, CaseIterable, Codable {
    case dramaQueen = "Drama Queen"
    case chillRoomie = "Chill Roomie"
    case grumpySenior = "Grumpy Senior"
    case sunshineBuddy = "Sunshine Buddy"
    case zenMaster = "Zen Master"
    
    var description: String {
        switch self {
        case .dramaQueen:
            return "Gen-Z slang, melodramatic, attention-seeking"
        case .chillRoomie:
            return "Laid back, supportive, easy-going"
        case .grumpySenior:
            return "Dry wit, disciplined, old-school"
        case .sunshineBuddy:
            return "Energetic, positive, enthusiastic"
        case .zenMaster:
            return "Calm, wise, meditative"
        }
    }
    
    var emoji: String {
        switch self {
        case .dramaQueen:
            return "💅"
        case .chillRoomie:
            return "😎"
        case .grumpySenior:
            return "🤨"
        case .sunshineBuddy:
            return "☀️"
        case .zenMaster:
            return "🧘"
        }
    }
}

enum PlantStatus: String, Codable {
    case hydrated = "Hydrated"
    case thirsty = "Thirsty"
    case critical = "Critical"
    
    var color: String {
        switch self {
        case .hydrated:
            return "green"
        case .thirsty:
            return "orange"
        case .critical:
            return "red"
        }
    }
    
    var emoji: String {
        switch self {
        case .hydrated:
            return "💧"
        case .thirsty:
            return "😓"
        case .critical:
            return "🚨"
        }
    }
}

struct Plant: Identifiable, Codable {
    let id: UUID
    let userId: UUID // Foreign key to User (many-to-one relationship)
    var nickname: String
    var species: String
    var vibe: PlantVibe
    var status: PlantStatus
    var lastWatered: Date?
    var healthStreak: Int // Days in a row of good care
    var qrCode: String? // Unique QR code identifier
    var location: String? // User's location for weather sync
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        nickname: String,
        species: String,
        vibe: PlantVibe,
        status: PlantStatus = .hydrated,
        lastWatered: Date? = nil,
        healthStreak: Int = 0,
        qrCode: String? = nil,
        location: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.nickname = nickname
        self.species = species
        self.vibe = vibe
        self.status = status
        self.lastWatered = lastWatered
        self.healthStreak = healthStreak
        self.qrCode = qrCode
        self.location = location
    }
}

// Plant species library (Top 50 most common houseplants)
struct PlantSpecies {
    static let commonSpecies = [
        // Top 20 Most Popular
        "Snake Plant", "Pothos", "Spider Plant", "Peace Lily", "ZZ Plant",
        "Rubber Plant", "Fiddle Leaf Fig", "Aloe Vera", "Boston Fern", "Chinese Evergreen",
        "Philodendron", "Dracaena", "Monstera Deliciosa", "Jade Plant", "English Ivy",
        "Bird of Paradise", "Dieffenbachia", "Calathea", "Maranta", "Anthurium",
        // 21-40
        "Croton", "Schefflera", "Ficus Benjamina", "Ponytail Palm", "Yucca",
        "Bromeliad", "Christmas Cactus", "African Violet", "Begonia", "Orchid",
        "Air Plant", "Peperomia", "Pilea", "Hoya", "Cast Iron Plant",
        "Money Tree", "Parlor Palm", "Areca Palm", "Majesty Palm", "Kentia Palm",
        // 41-50
        "String of Pearls", "String of Hearts", "Burro's Tail", "Echeveria", "Haworthia",
        "Prayer Plant", "Rattlesnake Plant", "Zebra Plant", "Nerve Plant", "Kalanchoe"
    ]
    
    /// Get emoji icon for a plant species
    static func emoji(for species: String) -> String {
        let lowercased = species.lowercased()
        
        // Snake Plant (distinct)
        if lowercased.contains("snake") {
            return "🐍"
        }
        // Trees
        if lowercased.contains("tree") || lowercased.contains("fig") || lowercased.contains("ficus") {
            return "🌳"
        }
        // Rubber Plant (tree-like)
        if lowercased.contains("rubber plant") {
            return "🌳"
        }
        // Succulents and cacti
        if lowercased.contains("cactus") || lowercased.contains("succulent") || lowercased.contains("aloe") || 
           lowercased.contains("echeveria") || lowercased.contains("haworthia") || lowercased.contains("lithops") ||
           lowercased.contains("jade") || lowercased.contains("burro") || lowercased.contains("kalanchoe") {
            return "🌵"
        }
        // Herbs
        if lowercased.contains("basil") || lowercased.contains("mint") || lowercased.contains("oregano") ||
           lowercased.contains("thyme") || lowercased.contains("sage") || lowercased.contains("parsley") ||
           lowercased.contains("cilantro") || lowercased.contains("chives") || lowercased.contains("rosemary") {
            return "🌿"
        }
        // Fruit trees
        if lowercased.contains("lemon") || lowercased.contains("lime") || lowercased.contains("orange") ||
           lowercased.contains("avocado") || lowercased.contains("mango") {
            return "🍋"
        }
        // Flowers
        if lowercased.contains("lily") || lowercased.contains("violet") || lowercased.contains("begonia") ||
           lowercased.contains("geranium") || lowercased.contains("petunia") || lowercased.contains("marigold") ||
           lowercased.contains("orchid") || lowercased.contains("anthurium") {
            return "🌸"
        }
        // Palms
        if lowercased.contains("palm") {
            return "🌴"
        }
        // Ferns
        if lowercased.contains("fern") {
            return "🍃"
        }
        // Bamboo
        if lowercased.contains("bamboo") {
            return "🎋"
        }
        // Bonsai
        if lowercased.contains("bonsai") {
            return "🪴"
        }
        // Vining plants
        if lowercased.contains("pothos") || lowercased.contains("philodendron") || lowercased.contains("string") ||
           lowercased.contains("hoya") || lowercased.contains("ivy") {
            return "🌱"
        }
        // Large leaf plants
        if lowercased.contains("monstera") || lowercased.contains("elephant") || lowercased.contains("caladium") ||
           lowercased.contains("bird of paradise") {
            return "🍀"
        }
        // Small decorative plants
        if lowercased.contains("pilea") || lowercased.contains("nerve") || lowercased.contains("peperomia") ||
           lowercased.contains("cast iron") {
            return "🪴"
        }
        // Default plant emoji
        return "🪴"
    }
}

