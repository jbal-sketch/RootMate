//
//  SettingsView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationTime: Date
    @Environment(\.dismiss) var dismiss
    
    private let notificationTimeKey = "notificationTime"
    
    @State private var apiKey: String
    
    init() {
        // Load saved API key or set default (pre-populate if not set)
        let savedApiKey = UserDefaults.standard.string(forKey: "gemini_api_key") ?? "AIzaSyBGaMbsDgg0kvsCGWBXuHF70ERjeyaQnww"
        if UserDefaults.standard.string(forKey: "gemini_api_key") == nil {
            // First time - save the default API key
            UserDefaults.standard.set(savedApiKey, forKey: "gemini_api_key")
        }
        _apiKey = State(initialValue: savedApiKey)
        
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
                Section(header: Text("AI Configuration")) {
                    TextField("Google Gemini API Key", text: $apiKey)
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Text("Enter your Google Gemini API key to enable daily chat messages. Get one at aistudio.google.com/app/apikey")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Notifications")) {
                    DatePicker(
                        "Notification Time",
                        selection: $notificationTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    
                    Text("You'll receive plant care reminders at this time each day.")
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
        }
    }
    
    private func saveNotificationTime() {
        // Save API key
        UserDefaults.standard.set(apiKey, forKey: "gemini_api_key")
        
        // Extract just the time components and save
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)
        
        // Create a reference date (Jan 1, 2000) with the selected time
        let referenceDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1, hour: hour, minute: minute)) ?? Date()
        UserDefaults.standard.set(referenceDate.timeIntervalSince1970, forKey: notificationTimeKey)
    }
}

#Preview {
    SettingsView()
}

