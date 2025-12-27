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
        let products = try await Product.products(for: [productId])
        return products.first
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
                                case .subscribed, .inGracePeriod, .inBillingRetryPeriod:
                                    // Check if we're in trial period by looking at purchase date
                                    // Trial is 7 days, so if purchase was within last 7 days, likely in trial
                                    let purchaseDate = transaction.purchaseDate
                                    let daysSincePurchase = Calendar.current.dateComponents([.day], from: purchaseDate, to: Date()).day ?? 0
                                    
                                    // If purchased within last 7 days, assume trial (StoreKit 2 will handle this properly)
                                    // We can also check the renewal info for more details
                                    if daysSincePurchase <= 7 {
                                        // Check if there's a renewal date that's 7 days from purchase
                                        // This is a heuristic - StoreKit 2 should provide this info
                                        status = .inTrial
                                    } else {
                                        status = .subscribed
                                    }
                                case .revoked, .expired:
                                    status = .expired
                                @unknown default:
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
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Helper Methods
    
    var isSubscribed: Bool {
        switch subscriptionStatus {
        case .subscribed, .inTrial:
            return true
        case .notSubscribed, .expired, .unknown:
            return false
        }
    }
    
    var isInTrial: Bool {
        subscriptionStatus == .inTrial
    }
    
    var canAddMorePlants: Bool {
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

