//
//  KeychainService.swift
//  RootMate
//
//  Secure storage for sensitive data like API keys using iOS Keychain
//

import Foundation
import Security

/// Service for securely storing and retrieving sensitive data using iOS Keychain
class KeychainService {
    static let shared = KeychainService()
    
    private let serviceName = "com.rootmate.RootMate"
    
    private init() {}
    
    /// Store a value in the Keychain
    /// - Parameters:
    ///   - value: The string value to store
    ///   - key: The key identifier
    /// - Returns: True if successful, false otherwise
    func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        
        // Delete existing item if it exists
        delete(key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Retrieve a value from the Keychain
    /// - Parameter key: The key identifier
    /// - Returns: The stored value, or nil if not found
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    /// Delete a value from the Keychain
    /// - Parameter key: The key identifier
    /// - Returns: True if successful, false otherwise
    @discardableResult
    func delete(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    /// Check if a key exists in the Keychain
    /// - Parameter key: The key identifier
    /// - Returns: True if the key exists, false otherwise
    func exists(_ key: String) -> Bool {
        return get(key) != nil
    }
}

