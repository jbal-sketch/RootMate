//
//  SubscriptionView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var subscriptionService = SubscriptionService.shared
    @Environment(\.dismiss) var dismiss
    @State private var product: Product?
    @State private var isLoadingProduct = false
    @State private var purchaseInProgress = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "D97706"))
                        
                        Text("RootMate Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "1B4332"))
                        
                        Text("Get daily updates for up to 5 plants")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "sparkles", text: "Daily AI-powered messages from your plants")
                        FeatureRow(icon: "cloud.sun.fill", text: "Weather-aware plant updates")
                        FeatureRow(icon: "bell.fill", text: "Smart notifications at your preferred time")
                        FeatureRow(icon: "leaf.fill", text: "Track up to 5 plants")
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Health streak tracking")
                        FeatureRow(icon: "qrcode", text: "QR code stickers for your plants")
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                    
                    // Pricing
                    if let product = product {
                        VStack(spacing: 12) {
                            Text("Start your 7-day free trial")
                                .font(.headline)
                                .foregroundColor(Color(hex: "1B4332"))
                            
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(product.displayPrice)
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(Color(hex: "1B4332"))
                                
                                Text("/month")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text("After 7-day free trial")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "E8F5E9"))
                        .cornerRadius(16)
                    } else if isLoadingProduct {
                        ProgressView()
                            .padding()
                    }
                    
                    // Error message
                    if let errorMessage = subscriptionService.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Subscribe button
                    Button(action: {
                        Task {
                            purchaseInProgress = true
                            do {
                                let success = try await subscriptionService.purchase()
                                if success {
                                    dismiss()
                                }
                            } catch {
                                print("Purchase error: \(error)")
                            }
                            purchaseInProgress = false
                        }
                    }) {
                        HStack {
                            if purchaseInProgress {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Start Free Trial")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "1B4332"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(purchaseInProgress || product == nil)
                    .padding(.horizontal)
                    
                    // Terms
                    VStack(spacing: 8) {
                        Text("By subscribing, you agree to our Terms of Service and Privacy Policy")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Subscription automatically renews unless cancelled at least 24 hours before the end of the current period. Manage subscriptions in your Apple ID settings.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [Color(hex: "FDFBF7"), Color(hex: "E8F5E9")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadProduct()
            }
        }
    }
    
    private func loadProduct() async {
        isLoadingProduct = true
        do {
            product = try await subscriptionService.loadProducts()
        } catch {
            print("Failed to load product: \(error)")
        }
        isLoadingProduct = false
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(hex: "1B4332"))
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    SubscriptionView()
}

