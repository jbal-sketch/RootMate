//
//  APIConfiguration.swift
//  RootMate
//
//  Centralized API configuration management
//

import Foundation

/// Manages API configuration and keys
class APIConfiguration {
    static let shared = APIConfiguration()
    
    private let keychain = KeychainService.shared
    private let apiKeyKey = "gemini_api_key"
    
    // For development: You can set a default key via build configuration
    // In Xcode: Build Settings > Swift Compiler - Custom Flags > Other Swift Flags
    // Add: -D DEBUG_API_KEY="your_key_here" (but still better to use Keychain)
    #if DEBUG
    // Only use this for local development, never commit real keys
    // Better approach: Use Keychain or environment variables
    private let debugAPIKey: String? = nil // Set to nil in production
    #endif
    
    private init() {}
    
    /// Get the stored API key
    /// - Returns: The API key if available, nil otherwise
    func getAPIKey() -> String? {
        // First, try to get from Keychain
        if let key = keychain.get(apiKeyKey), !key.isEmpty {
            return key
        }
        
        // Default API key (Gemini 1.5 Pro)
        return "AIzaSyD85YnWDsK0WY8LkmFq1z_5CSu_IGsiXKs"
    }
    
    /// Store an API key securely
    /// - Parameter key: The API key to store
    /// - Returns: True if successful, false otherwise
    func setAPIKey(_ key: String) -> Bool {
        guard !key.isEmpty else {
            return false
        }
        return keychain.set(key, forKey: apiKeyKey)
    }
    
    /// Check if an API key is configured
    /// - Returns: True if an API key exists, false otherwise
    func hasAPIKey() -> Bool {
        return getAPIKey() != nil
    }
    
    /// Remove the stored API key
    /// - Returns: True if successful, false otherwise
    func removeAPIKey() -> Bool {
        return keychain.delete(apiKeyKey)
    }
}

