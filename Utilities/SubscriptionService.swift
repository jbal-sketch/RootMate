//
//  SubscriptionService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation
import StoreKit
import SwiftUI

@MainActor
class SubscriptionService: ObservableObject {
    static let shared = SubscriptionService()
    
    @Published var subscriptionStatus: SubscriptionStatus = .notSubscribed
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Product ID - This must match what you configure in App Store Connect
    private let productId = "com.rootmate.premium.monthly"
    
    private var updateListenerTask: Task<Void, Error>?
    private var currentEntitlements: [Product.SubscriptionInfo.Status] = []
    
    // MARK: - Debug Bypass (DEBUG builds only)
    #if DEBUG
    private let bypassKey = "debugBypassSubscription"
    
    /// Enable/disable subscription bypass for testing (DEBUG builds only)
    var debugBypassEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: bypassKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bypassKey)
            // Update status immediately when toggled
            if newValue {
                subscriptionStatus = .subscribed
            } else {
                Task {
                    await checkSubscriptionStatus()
                }
            }
        }
    }
    #endif
    
    enum SubscriptionStatus {
        case notSubscribed
        case inTrial
        case subscribed
        case expired
        case unknown
    }
    
    private init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()
        
        // Load initial subscription status
        Task {
            await checkSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - StoreKit 2 Transaction Listener
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try self?.checkVerified(result)
                    await transaction?.finish()
                    await self?.checkSubscriptionStatus()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Product Loading
    
    func loadProducts() async throws -> Product? {
        do {
            let products = try await Product.products(for: [productId])
            
            if products.isEmpty {
                print("⚠️ No products found for ID: \(productId)")
                print("💡 Make sure:")
                print("   1. Product ID matches App Store Connect exactly: \(productId)")
                print("   2. Subscription is created and approved in App Store Connect")
                print("   3. You're testing with a sandbox account (not simulator)")
                throw SubscriptionError.productNotFound
            }
            
            return products.first
        } catch {
            print("❌ Failed to load products: \(error)")
            if let storeKitError = error as? StoreKitError {
                print("   StoreKit error: \(storeKitError)")
            }
            throw error
        }
    }
    
    // MARK: - Purchase
    
    func purchase() async throws -> Bool {
        guard let product = try await loadProducts() else {
            throw SubscriptionError.productNotFound
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await checkSubscriptionStatus()
                isLoading = false
                return true
                
            case .userCancelled:
                isLoading = false
                return false
                
            case .pending:
                isLoading = false
                errorMessage = "Purchase is pending approval"
                return false
                
            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    // MARK: - Subscription Status Check
    
    func checkSubscriptionStatus() async {
        var status: SubscriptionStatus = .notSubscribed
        
        // Check current entitlements
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                // Check if this is our subscription product
                if transaction.productID == productId {
                    // Check if subscription is still active
                    if let expirationDate = transaction.expirationDate {
                        if expirationDate > Date() {
                            // Get subscription status
                            if let subscriptionInfo = try? await transaction.subscriptionStatus {
                                // Check subscription state
                                switch subscriptionInfo.state {
                                case .subscribed:
                                    // Check if we're in trial period by looking at purchase date
                                    let purchaseDate = transaction.purchaseDate
                                    let daysSincePurchase = Calendar.current.dateComponents([.day], from: purchaseDate, to: Date()).day ?? 0
                                    
                                    if daysSincePurchase <= 7 {
                                        status = .inTrial
                                    } else {
                                        status = .subscribed
                                    }
                                case .inGracePeriod:
                                    // Grace period - treat as subscribed
                                    status = .subscribed
                                case .inBillingRetryPeriod:
                                    // Billing retry period - treat as subscribed
                                    status = .subscribed
                                case .revoked:
                                    status = .expired
                                case .expired:
                                    status = .expired
                                default:
                                    // Handle any other cases (including future enum additions)
                                    status = .unknown
                                }
                            } else {
                                // Fallback: check purchase date
                                let purchaseDate = transaction.purchaseDate
                                let daysSincePurchase = Calendar.current.dateComponents([.day], from: purchaseDate, to: Date()).day ?? 0
                                
                                if daysSincePurchase <= 7 {
                                    status = .inTrial
                                } else {
                                    status = .subscribed
                                }
                            }
                        } else {
                            status = .expired
                        }
                    } else {
                        // No expiration date means it's a non-consumable or lifetime purchase
                        status = .subscribed
                    }
                }
            } catch {
                print("Error checking entitlement: \(error)")
            }
        }
        
        subscriptionStatus = status
    }
    
    // MARK: - Verification
    
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Helper Methods
    
    var isSubscribed: Bool {
        #if DEBUG
        // Bypass subscription checks in DEBUG builds if enabled
        if debugBypassEnabled {
            return true
        }
        #endif
        
        switch subscriptionStatus {
        case .subscribed, .inTrial:
            return true
        case .notSubscribed, .expired, .unknown:
            return false
        }
    }
    
    var isInTrial: Bool {
        #if DEBUG
        if debugBypassEnabled {
            return false // When bypassed, treat as fully subscribed
        }
        #endif
        return subscriptionStatus == .inTrial
    }
    
    var canAddMorePlants: Bool {
        #if DEBUG
        // Bypass subscription checks in DEBUG builds if enabled
        if debugBypassEnabled {
            return true
        }
        #endif
        
        // Subscribers can have up to 5 plants
        return isSubscribed
    }
    
    var maxPlants: Int {
        return 5
    }
}

enum SubscriptionError: LocalizedError {
    case productNotFound
    case failedVerification
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Subscription product not found. Please try again later."
        case .failedVerification:
            return "Failed to verify purchase. Please contact support."
        case .purchaseFailed:
            return "Purchase failed. Please try again."
        }
    }
}

