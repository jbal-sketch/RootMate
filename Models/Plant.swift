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
    
    var description: String {
        switch self {
        case .dramaQueen:
            return "Gen-Z slang, melodramatic, attention-seeking"
        case .chillRoomie:
            return "Laid back, supportive, easy-going"
        case .grumpySenior:
            return "Dry wit, disciplined, old-school"
        }
    }
    
    var emoji: String {
        switch self {
        case .dramaQueen:
            return "💅"
        case .chillRoomie:
            return "🌿"
        case .grumpySenior:
            return "🌳"
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

// Plant species library (100 common houseplants)
struct PlantSpecies {
    static let commonSpecies = [
        "Fiddle Leaf Fig", "Monstera Deliciosa", "Snake Plant", "Pothos", "ZZ Plant",
        "Peace Lily", "Spider Plant", "Rubber Plant", "Philodendron", "Aloe Vera",
        "Jade Plant", "English Ivy", "Boston Fern", "Bird of Paradise", "Dracaena",
        "Chinese Evergreen", "Dieffenbachia", "Calathea", "Maranta", "Anthurium",
        "Croton", "Schefflera", "Ficus Benjamina", "Ponytail Palm", "Yucca",
        "Aglaonema", "Bromeliad", "Christmas Cactus", "African Violet", "Begonia",
        "Coleus", "Impatiens", "Geranium", "Petunia", "Marigold",
        "Lavender", "Rosemary", "Basil", "Mint", "Oregano",
        "Thyme", "Sage", "Parsley", "Cilantro", "Chives",
        "Lemon Tree", "Lime Tree", "Orange Tree", "Avocado", "Mango",
        "Bamboo", "Lucky Bamboo", "Bonsai", "Juniper", "Cypress",
        "Orchid", "Bromeliad", "Air Plant", "String of Pearls", "String of Hearts",
        "Burro's Tail", "Echeveria", "Hens and Chicks", "Aloe", "Haworthia",
        "Lithops", "Christmas Cactus", "Easter Cactus", "Barrel Cactus", "Prickly Pear",
        "Ponytail Palm", "Areca Palm", "Majesty Palm", "Kentia Palm", "Parlor Palm",
        "Fiddle Leaf Fig", "Rubber Tree", "Weeping Fig", "Ficus Lyrata", "Ficus Elastica",
        "Swiss Cheese Plant", "Split-Leaf Philodendron", "Elephant Ear", "Caladium", "Taro",
        "Arrowhead Plant", "Heartleaf Philodendron", "Pothos", "Devil's Ivy", "Golden Pothos",
        "Marble Queen Pothos", "Neon Pothos", "Satin Pothos", "Peperomia", "Radiator Plant",
        "Prayer Plant", "Rattlesnake Plant", "Zebra Plant", "Peacock Plant", "Stromanthe"
    ]
}

