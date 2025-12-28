//
//  APIConfiguration.swift
//  RootMate
//
//  Centralized API configuration management
//

import Foundation

/// Manages API configuration
/// Note: API keys are now handled by the backend server, so users no longer need to configure their own keys
class APIConfiguration {
    static let shared = APIConfiguration()
    
    // Backend API base URL
    // Production Vercel deployment URL
    var backendBaseURL: String {
        return "https://root-mate.vercel.app"
    }
    
    /// Get the full backend API URL for generating messages
    var generateMessageURL: String {
        return "\(backendBaseURL)/api/generate-message"
    }
    
    private init() {}
    
    // Legacy methods kept for backward compatibility but no longer used
    // These can be removed in a future version if not needed
    
    /// Check if API is configured (always returns true now since backend handles keys)
    /// - Returns: Always returns true
    func hasAPIKey() -> Bool {
        return true // Backend always has API key configured
    }
}

