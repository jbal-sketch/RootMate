//
//  NotificationService.swift
//  RootMate
//
//  Created on $(date)
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    // Request notification permissions
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }
    
    // Schedule daily notifications for all plants
    func scheduleNotifications(for plants: [Plant], at time: Date, viewModel: PlantViewModel? = nil) {
        let center = UNUserNotificationCenter.current()
        
        // Remove all existing plant notifications
        center.removePendingNotificationRequests(withIdentifiers: plants.map { "plant_\($0.id.uuidString)" })
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        // Schedule a notification for each plant
        for plant in plants {
            let content = UNMutableNotificationContent()
            content.title = "\(plant.nickname) needs attention! 🌱"
            content.body = getNotificationBody(for: plant)
            content.sound = .default
            content.badge = NSNumber(value: 1)
            content.categoryIdentifier = "PLANT_REMINDER"
            
            // Add plant ID to userInfo for deep linking
            content.userInfo = ["plantId": plant.id.uuidString, "shouldGenerateMessage": true]
            
            // Schedule for daily at the specified time
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "plant_\(plant.id.uuidString)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification for \(plant.nickname): \(error)")
                } else {
                    print("Scheduled notification for \(plant.nickname) at \(hour):\(String(format: "%02d", minute))")
                }
            }
        }
    }
    
    // Generate daily messages for all plants (called when notifications fire)
    @MainActor
    func generateDailyMessagesForAllPlants(viewModel: PlantViewModel) async {
        print("🌱 Generating daily messages for all plants...")
        
        // Ensure API key is loaded before generating messages
        viewModel.reloadAPIKey()
        
        // Check if API key is configured
        if !APIConfiguration.shared.hasAPIKey() {
            print("⚠️ API key not configured. Please set Gemini API key in Settings.")
            return
        }
        
        // Access plants on main actor
        let plants = viewModel.plants
        
        for plant in plants {
            // Only generate if message doesn't exist for today
            if !viewModel.hasMessageForToday(for: plant.id) {
                do {
                    _ = try await viewModel.generateDailyMessage(for: plant)
                    print("✅ Generated message for \(plant.nickname)")
                } catch {
                    print("❌ Failed to generate message for \(plant.nickname): \(error)")
                }
            } else {
                print("⏭️ Message already exists for \(plant.nickname) today")
            }
        }
    }
    
    // Get notification body based on plant status
    private func getNotificationBody(for plant: Plant) -> String {
        switch plant.status {
        case .thirsty:
            return "\(plant.nickname) is thirsty! Time for a drink 💧"
        case .critical:
            return "🚨 \(plant.nickname) needs urgent care! Please water immediately."
        case .hydrated:
            return "\(plant.nickname) says hello! Check in with your rootmate today 🌿"
        }
    }
    
    // Check notification authorization status
    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // Test notification - sends immediately for testing
    func sendTestNotification(for plant: Plant) async {
        // Check authorization first
        let status = await checkAuthorizationStatus()
        guard status == .authorized else {
            print("Notifications not authorized. Status: \(status.rawValue)")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Test: \(plant.nickname) 🌱"
        content.body = getNotificationBody(for: plant)
        content.sound = .default
        content.badge = NSNumber(value: 1)
        content.userInfo = ["plantId": plant.id.uuidString, "isTest": true]
        
        // Use immediate trigger (0 seconds) for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "test_\(plant.id.uuidString)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
            print("✅ Test notification sent for \(plant.nickname)")
        } catch {
            print("❌ Error sending test notification: \(error)")
        }
    }
    
    // Send test notifications for all plants
    func sendTestNotificationsForAll(plants: [Plant], viewModel: PlantViewModel? = nil) async {
        // Check authorization first
        let status = await checkAuthorizationStatus()
        guard status == .authorized else {
            print("❌ Notifications not authorized. Status: \(status.rawValue)")
            print("Please grant notification permissions in iOS Settings > RootMate > Notifications")
            return
        }
        
        print("📱 Sending test notifications for \(plants.count) plants...")
        
        // Generate daily messages for all plants first (if viewModel provided)
        if let viewModel = viewModel {
            await generateDailyMessagesForAllPlants(viewModel: viewModel)
        }
        
        // Then send notifications
        for (index, plant) in plants.enumerated() {
            // Stagger notifications by 1 second each
            try? await Task.sleep(nanoseconds: UInt64(index * 1_000_000_000))
            await sendTestNotification(for: plant)
        }
        
        print("✅ All test notifications sent!")
    }
    
    // Cancel all plant notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications cancelled")
    }
    
    // Get pending notifications count
    func getPendingNotificationsCount() async -> Int {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return requests.count
    }
}

