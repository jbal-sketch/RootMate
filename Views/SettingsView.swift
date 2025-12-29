//
//  SettingsView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @State private var notificationTime: Date
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PlantViewModel
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    private let notificationTimeKey = "notificationTime"
    private let userLocationKey = "userLocation"
    
    @State private var userLocation: String
    @State private var showingSubscription = false
    
    init(viewModel: PlantViewModel) {
        self.viewModel = viewModel
        
        // Load saved user location
        let savedLocation = UserDefaults.standard.string(forKey: "userLocation") ?? ""
        _userLocation = State(initialValue: savedLocation)
        
        // Load saved notification time or default to 9:00 AM
        let savedTime: Date
        if let savedTimeInterval = UserDefaults.standard.object(forKey: "notificationTime") as? TimeInterval {
            // Reconstruct date with today's date but saved time
            let calendar = Calendar.current
            let now = Date()
            let savedDate = Date(timeIntervalSince1970: savedTimeInterval)
            let hour = calendar.component(.hour, from: savedDate)
            let minute = calendar.component(.minute, from: savedDate)
            savedTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? Date()
        } else {
            savedTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        }
        _notificationTime = State(initialValue: savedTime)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Subscription")) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(subscriptionStatusText)
                                .font(.headline)
                                .foregroundColor(Color(hex: "1B4332"))
                            
                            Text(subscriptionDetailText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if !subscriptionService.isSubscribed {
                            Button(action: {
                                showingSubscription = true
                            }) {
                                Text("Subscribe")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(hex: "1B4332"))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    if subscriptionService.isSubscribed {
                        Button(action: {
                            // Open App Store subscription management
                            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Manage Subscription")
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Location")) {
                    TextField("City (e.g., Edinburgh, Scotland)", text: $userLocation)
                        .autocapitalization(.words)
                    
                    Text("Enter your city for weather-aware plant messages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                #if DEBUG
                Section(header: Text("Debug Options")) {
                    Toggle("Bypass Subscription Checks", isOn: Binding(
                        get: { subscriptionService.debugBypassEnabled },
                        set: { subscriptionService.debugBypassEnabled = $0 }
                    ))
                    
                    Text("Enable this to test all premium features without a subscription. Only available in DEBUG builds.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                #endif
                
                Section(header: Text("Notifications")) {
                    DatePicker(
                        "Daily Message Time",
                        selection: $notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                    
                    Text("You'll receive daily messages from your plants at this time.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveNotificationTime()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingSubscription) {
                SubscriptionView()
            }
            .task {
                await subscriptionService.checkSubscriptionStatus()
            }
        }
    }
    
    private var subscriptionStatusText: String {
        #if DEBUG
        if subscriptionService.debugBypassEnabled {
            return "Premium Active (Debug Bypass)"
        }
        #endif
        
        switch subscriptionService.subscriptionStatus {
        case .subscribed:
            return "Premium Active"
        case .inTrial:
            return "Free Trial Active"
        case .notSubscribed:
            return "Not Subscribed"
        case .expired:
            return "Subscription Expired"
        case .unknown:
            return "Subscription Status Unknown"
        }
    }
    
    private var subscriptionDetailText: String {
        #if DEBUG
        if subscriptionService.debugBypassEnabled {
            return "Debug bypass enabled - All premium features unlocked for testing"
        }
        #endif
        
        switch subscriptionService.subscriptionStatus {
        case .subscribed:
            return "You have access to daily updates for up to 5 plants"
        case .inTrial:
            return "Free trial active. \(viewModel.plants.count)/5 plants"
        case .notSubscribed:
            return "Subscribe to get daily updates for up to 5 plants"
        case .expired:
            return "Your subscription has expired"
        case .unknown:
            return "Unable to verify subscription status"
        }
    }
    
    private func saveNotificationTime() {
        // Extract just the time components and save
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)
        
        // Create a reference date (Jan 1, 2000) with the selected time
        let referenceDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1, hour: hour, minute: minute)) ?? Date()
        UserDefaults.standard.set(referenceDate.timeIntervalSince1970, forKey: notificationTimeKey)
        
        // Save user location
        UserDefaults.standard.set(userLocation, forKey: userLocationKey)
        
        // Schedule notifications for all plants at the new time
        NotificationService.shared.scheduleNotifications(for: viewModel.plants, at: notificationTime, viewModel: viewModel)
        
    }
}

#Preview {
    SettingsView(viewModel: PlantViewModel())
}

