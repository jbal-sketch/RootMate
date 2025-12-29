//
//  MyRootmatesView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI
import UIKit

struct MyRootmatesView: View {
    @StateObject private var viewModel = PlantViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingAddPlant = false
    @State private var showingSettings = false
    @State private var showingSubscription = false
    @State private var selectedPlantId: UUID?
    @State private var showingSubscriptionAlert = false
    @State private var subscriptionAlertMessage = ""
    @State private var isEditMode = false
    @State private var showingDeleteConfirmation = false
    @State private var plantToDelete: Plant?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "FDFBF7"), // Cream
                        Color(hex: "E8F5E9")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Daily Messages Feed (Prominent!)
                        dailyMessagesFeed
                        
                        // Header Stats
                        headerStatsView
                        
                        // Rootmate List
                        rootmateListView
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle("My Rootmates")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: "1B4332"))
                        }
                        
                        if !viewModel.plants.isEmpty {
                            Button(action: {
                                withAnimation {
                                    isEditMode.toggle()
                                }
                            }) {
                                Text(isEditMode ? "Done" : "Edit")
                                    .foregroundColor(Color(hex: "1B4332"))
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Check subscription status before allowing add
                        Task {
                            await viewModel.subscriptionService.checkSubscriptionStatus()
                        }
                        
                        // Check if user can add more plants
                        let canAdd = viewModel.plants.count < viewModel.subscriptionService.maxPlants || viewModel.subscriptionService.isSubscribed
                        
                        if canAdd {
                            showingAddPlant = true
                        } else {
                            subscriptionAlertMessage = "Subscribe to RootMate Premium to add more than \(viewModel.subscriptionService.maxPlants) plants. Get daily updates for up to \(viewModel.subscriptionService.maxPlants) plants with a 7-day free trial."
                            showingSubscriptionAlert = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "1B4332"))
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView(viewModel: viewModel, onPlantAdded: { plant in
                    do {
                        try viewModel.addPlant(plant)
                    } catch {
                        subscriptionAlertMessage = error.localizedDescription
                        showingSubscriptionAlert = true
                        showingAddPlant = false
                    }
                })
            }
            .sheet(isPresented: $showingSubscription) {
                SubscriptionView()
            }
            .alert("Subscription Required", isPresented: $showingSubscriptionAlert) {
                Button("Subscribe") {
                    showingSubscription = true
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(subscriptionAlertMessage)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .sheet(isPresented: Binding(
                get: { selectedPlantId != nil },
                set: { if !$0 { selectedPlantId = nil } }
            )) {
                if let plantId = selectedPlantId {
                    PlantDetailView(plantId: plantId, viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.refreshAllStatuses()
                
                // Store view model reference for notification handling
                AppState.sharedViewModel = viewModel
                
                // Check subscription status
                Task {
                    await viewModel.subscriptionService.checkSubscriptionStatus()
                }
                
                // Schedule notifications on app appear
                scheduleNotificationsIfNeeded()
                
                // Generate messages - initial welcome for FTUE, then daily messages
                let viewModelRef = viewModel
                Task { @MainActor in
                    // First: generate initial message for first-time users (one-time only)
                    await viewModelRef.generateInitialMessageIfNeeded()
                    // Then: generate daily messages if it's past notification time
                    await viewModelRef.generateDailyMessagesIfNeeded()
                }
            }
            .onChange(of: appState.selectedPlantId) { newValue in
                if let plantId = newValue {
                    selectedPlantId = plantId
                    appState.selectedPlantId = nil // Reset after handling
                }
            }
        }
    }
    
    // MARK: - Daily Messages Feed
    private var dailyMessagesFeed: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💬 Daily Messages")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1B4332"))
                .padding(.horizontal, 4)
            
            if viewModel.recentMessages.isEmpty {
                // Empty state - encourage first message
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color(hex: "1B4332").opacity(0.3))
                    
                    Text("No messages yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Tap 'Get Today's Message' on any plant to start chatting!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.6))
                .cornerRadius(16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.recentMessages) { message in
                            MessageCard(message: message, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
    
    // MARK: - Header Stats
    private var headerStatsView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Rootmates")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "5C6B5E")) // Dark gray-green for visibility
                    Text("\(viewModel.plants.count)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "1B4332"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Hydrated")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "5C6B5E")) // Dark gray-green for visibility
                    Text("\(hydratedCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "2E7D32")) // Darker green for better contrast
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Rootmate List
    private var rootmateListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Plant Rootmates")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "1B4332"))
                .padding(.horizontal, 4)
            
            if viewModel.plants.isEmpty {
                emptyStateView
            } else {
                ForEach(viewModel.plants) { plant in
                    HStack(spacing: 12) {
                        // Delete button in edit mode
                        if isEditMode {
                            Button(action: {
                                plantToDelete = plant
                                showingDeleteConfirmation = true
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                        
                        RootmateCard(plant: plant, viewModel: viewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    plantToDelete = plant
                                    showingDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .alert("Delete Plant", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                plantToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let plant = plantToDelete {
                    withAnimation {
                        viewModel.deletePlant(plant.id)
                    }
                    plantToDelete = nil
                    // Exit edit mode if no plants left
                    if viewModel.plants.isEmpty {
                        isEditMode = false
                    }
                }
            }
        } message: {
            if let plant = plantToDelete {
                Text("Are you sure you want to delete \(plant.nickname)? This action cannot be undone.")
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "1B4332").opacity(0.3))
            
            Text("No rootmates yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text("Add your first plant to get started!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var hydratedCount: Int {
        viewModel.plants.filter { $0.status == .hydrated }.count
    }
    
    // Schedule notifications if time is set
    private func scheduleNotificationsIfNeeded() {
        if let savedTimeInterval = UserDefaults.standard.object(forKey: "notificationTime") as? TimeInterval {
            let calendar = Calendar.current
            let savedDate = Date(timeIntervalSince1970: savedTimeInterval)
            let hour = calendar.component(.hour, from: savedDate)
            let minute = calendar.component(.minute, from: savedDate)
            let notificationTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
            
            NotificationService.shared.scheduleNotifications(for: viewModel.plants, at: notificationTime, viewModel: viewModel)
        } else {
            // Default to 9 AM
            let defaultTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
            NotificationService.shared.scheduleNotifications(for: viewModel.plants, at: defaultTime, viewModel: viewModel)
        }
    }
    
}

// MARK: - Rootmate Card
struct RootmateCard: View {
    let plant: Plant
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingDetails = false
    @State private var showingChat = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                showingDetails = true
            }) {
                HStack(spacing: 16) {
                    // Plant Icon & Status
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Text(PlantSpecies.emoji(for: plant.species))
                            .font(.system(size: 32))
                    }
                    
                    // Plant Info
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(plant.nickname)
                                .font(.headline)
                                .foregroundColor(Color(hex: "1B4332"))
                            
                            Text(plant.vibe.emoji)
                                .font(.caption)
                        }
                        
                        Text(plant.species)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Status Badge
                        HStack(spacing: 8) {
                            statusBadge
                            healthStreakBadge
                        }
                    }
                    
                    Spacer()
                    
                    // Status Indicator
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.white.opacity(0.9))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Action Buttons
            HStack(spacing: 12) {
                // Water Button (only show when plant needs water)
                if plant.status == .thirsty || plant.status == .critical {
                    Button(action: {
                        viewModel.waterPlant(plant.id)
                    }) {
                        HStack {
                            Image(systemName: "drop.fill")
                            Text("Water")
                        }
                        .font(.system(.subheadline, design: .default).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                }
                
                // Chat Button
                Button(action: {
                    showingChat = true
                }) {
                    HStack {
                        Image(systemName: viewModel.hasMessageForToday(for: plant.id) ? "bubble.left.fill" : "sparkles")
                        Text(viewModel.hasMessageForToday(for: plant.id) ? "View Message" : "Get Message")
                    }
                    .font(.system(.subheadline, design: .default).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.hasMessageForToday(for: plant.id) ? Color(hex: "1B4332").opacity(0.8) : Color(hex: "1B4332"))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showingDetails) {
            PlantDetailView(plantId: plant.id, viewModel: viewModel)
        }
        .sheet(isPresented: $showingChat) {
            PlantChatView(plant: plant, viewModel: viewModel)
        }
    }
    
    private var statusColor: Color {
        switch plant.status {
        case .hydrated:
            return .green
        case .thirsty:
            return Color(hex: "D97706") // Terracotta
        case .critical:
            return .red
        }
    }
    
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Text(plant.status.emoji)
                .font(.caption2)
            Text(plant.status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(statusColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.15))
        .cornerRadius(8)
    }
    
    private var healthStreakBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.caption2)
            Text("\(plant.healthStreak)")
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(Color(hex: "D97706"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: "D97706").opacity(0.15))
        .cornerRadius(8)
    }
}

// MARK: - Message Card (for Feed)
struct MessageCard: View {
    let message: PlantMessage
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingChat = false
    
    var body: some View {
        Button(action: {
            if let plant = viewModel.plants.first(where: { $0.id == message.plantId }) {
                showingChat = true
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Plant Header
                HStack(spacing: 8) {
                    Text(PlantSpecies.emoji(for: message.plantSpecies))
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(message.plantNickname)
                            .font(.headline)
                            .foregroundColor(Color(hex: "1B4332"))
                        
                        HStack(spacing: 4) {
                            Text(message.plantVibe.emoji)
                                .font(.caption)
                            Text(message.plantSpecies)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Message Preview
                Text(message.message)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Timestamp
                HStack {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(timeAgoString(from: message.date))
                        .font(.caption2)
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .frame(width: 280)
            .background(Color.white.opacity(0.95))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingChat) {
            if let plant = viewModel.plants.first(where: { $0.id == message.plantId }) {
                PlantChatView(plant: plant, viewModel: viewModel)
            }
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }
}

// MARK: - Plant Detail View
struct PlantDetailView: View {
    let plantId: UUID
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingEditPlant = false
    @State private var showingChat = false
    @State private var showingQRCode = false
    @State private var showingPhotoComingSoon = false
    
    private var plant: Plant? {
        viewModel.plants.first(where: { $0.id == plantId })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let plant = plant {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                ZStack(alignment: .bottomTrailing) {
                                    Text(PlantSpecies.emoji(for: plant.species))
                                        .font(.system(size: 50))
                                    Text(plant.vibe.emoji)
                                        .font(.system(size: 20))
                                        .offset(x: 4, y: 4)
                                }
                                VStack(alignment: .leading) {
                                    Text(plant.nickname)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "1B4332"))
                                    Text(plant.species)
                                        .font(.title3)
                                        .foregroundColor(Color(hex: "5C6B5E"))
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(16)
                    
                        // Health Streak
                        healthStreakSection(plant: plant)
                        
                        // Status Info
                        statusSection(plant: plant)
                        
                        // Actions
                        actionButtons(plant: plant, showingQRCode: $showingQRCode)
                        
                        // Daily Chat Section
                        dailyChatSection(plant: plant)
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(hex: "FDFBF7"), Color(hex: "E8F5E9")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Plant Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let plant = plant {
                        Button("Edit") {
                            showingEditPlant = true
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingEditPlant) {
                if let plant = plant {
                    EditPlantView(plant: plant, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showingChat) {
                if let plant = plant {
                    PlantChatView(plant: plant, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showingQRCode) {
                if let plant = plant {
                    QRCodeView(plant: plant, onDismiss: {
                        showingQRCode = false
                    })
                }
            }
            .sheet(isPresented: $showingChat) {
                if let plant = plant {
                    PlantChatView(plant: plant, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showingPhotoComingSoon) {
                PhotoComingSoonView()
            }
        }
    }
    
    // Log photo button usage
    private func logPhotoButtonUsage() {
        let timestamp = Date()
        let count = UserDefaults.standard.integer(forKey: "photoButtonOpenCount")
        let newCount = count + 1
        UserDefaults.standard.set(newCount, forKey: "photoButtonOpenCount")
        
        print("📸 Photo button opened - Count: \(newCount), Timestamp: \(timestamp)")
        
        // Also log to console with plant info if available
        if let plant = plant {
            print("   Plant: \(plant.nickname) (\(plant.species))")
        }
    }
    
    private func healthStreakSection(plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Streak")
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
            
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(Color(hex: "D97706"))
                    .font(.title2)
                
                Text("\(plant.healthStreak) days")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "D97706"))
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
        }
    }
    
    private func statusSection(plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Status")
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(plant.status.emoji)
                        .font(.title)
                    Text(plant.status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Divider()
                
                if let lastWatered = plant.lastWatered {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Last Watered")
                                .font(.caption)
                                .foregroundColor(Color(hex: "5C6B5E"))
                            Text(formatDateTime(lastWatered))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "1B4332"))
                        }
                        Spacer()
                        
                        let daysSince = Calendar.current.dateComponents([.day], from: lastWatered, to: Date()).day ?? 0
                        Text("\(daysSince) day\(daysSince == 1 ? "" : "s") ago")
                            .font(.caption)
                            .foregroundColor(Color(hex: "5C6B5E"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "E8F5E9"))
                            .cornerRadius(8)
                    }
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "drop")
                            .foregroundColor(.orange)
                        Text("Never watered yet")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func actionButtons(plant: Plant, showingQRCode: Binding<Bool>) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.waterPlant(plant.id)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "drop.fill")
                    Text("Water Plant")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "1B4332"))
                .cornerRadius(12)
            }
            
            Button(action: {
                // Log photo button usage
                logPhotoButtonUsage()
                showingPhotoComingSoon = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Take Photo")
                }
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "1B4332"), lineWidth: 2)
                )
            }
            
            Button(action: {
                showingQRCode.wrappedValue = true
            }) {
                HStack {
                    Image(systemName: "qrcode")
                    Text("View QR Code")
                }
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "1B4332"), lineWidth: 2)
                )
            }
        }
    }
    
    private func dailyChatSection(plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Chat")
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
            
            Button(action: {
                showingChat = true
            }) {
                HStack {
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(Color(hex: "1B4332"))
                    Text("Chat with \(plant.nickname)")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(Color(hex: "1B4332"))
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Add Plant View (Simplified)
struct AddPlantView: View {
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nickname = ""
    @State private var selectedSpecies = "Monstera Deliciosa"
    @State private var selectedVibe: PlantVibe = .chillRoomie
    var onPlantAdded: ((Plant) -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Plant Details") {
                    TextField("Nickname", text: $nickname)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Species")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "5C6B5E"))
                        
                        Menu {
                            ForEach(PlantSpecies.commonSpecies, id: \.self) { species in
                                Button(action: {
                                    selectedSpecies = species
                                }) {
                                    Label {
                                        Text(species)
                                    } icon: {
                                        Text(PlantSpecies.emoji(for: species))
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(PlantSpecies.emoji(for: selectedSpecies))
                                    .font(.title3)
                                Text(selectedSpecies)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "5C6B5E"))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vibe")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "5C6B5E"))
                        
                        Menu {
                            ForEach(PlantVibe.allCases, id: \.self) { vibe in
                                Button(action: {
                                    selectedVibe = vibe
                                }) {
                                    Label {
                                        Text(vibe.rawValue)
                                    } icon: {
                                        Text(vibe.emoji)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedVibe.emoji)
                                    .font(.title3)
                                Text(selectedVibe.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "5C6B5E"))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Add Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let plantId = UUID()
                        let newPlant = Plant(
                            id: plantId,
                            userId: viewModel.currentUserId,
                            nickname: nickname.isEmpty ? selectedSpecies : nickname,
                            species: selectedSpecies,
                            vibe: selectedVibe,
                            qrCode: plantId.uuidString // Generate QR code identifier
                        )
                        
                        if let onPlantAdded = onPlantAdded {
                            onPlantAdded(newPlant)
                        } else {
                            do {
                                try viewModel.addPlant(newPlant)
                                dismiss()
                            } catch {
                                // Error handling is done in parent view
                                print("Error adding plant: \(error)")
                            }
                        }
                    }
                    .disabled(nickname.isEmpty)
                }
            }
        }
    }
}

// MARK: - Edit Plant View
struct EditPlantView: View {
    let plant: Plant
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nickname: String
    @State private var selectedSpecies: String
    @State private var selectedVibe: PlantVibe
    
    init(plant: Plant, viewModel: PlantViewModel) {
        self.plant = plant
        self.viewModel = viewModel
        _nickname = State(initialValue: plant.nickname)
        _selectedSpecies = State(initialValue: plant.species)
        _selectedVibe = State(initialValue: plant.vibe)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Plant Details") {
                    TextField("Nickname", text: $nickname)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Species")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "5C6B5E"))
                        
                        Menu {
                            ForEach(PlantSpecies.commonSpecies, id: \.self) { species in
                                Button(action: {
                                    selectedSpecies = species
                                }) {
                                    Label {
                                        Text(species)
                                    } icon: {
                                        Text(PlantSpecies.emoji(for: species))
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(PlantSpecies.emoji(for: selectedSpecies))
                                    .font(.title3)
                                Text(selectedSpecies)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "5C6B5E"))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vibe")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "5C6B5E"))
                        
                        Menu {
                            ForEach(PlantVibe.allCases, id: \.self) { vibe in
                                Button(action: {
                                    selectedVibe = vibe
                                }) {
                                    Label {
                                        Text(vibe.rawValue)
                                    } icon: {
                                        Text(vibe.emoji)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedVibe.emoji)
                                    .font(.title3)
                                Text(selectedVibe.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "5C6B5E"))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Edit Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.updatePlant(
                            plant.id,
                            nickname: nickname.isEmpty ? selectedSpecies : nickname,
                            species: selectedSpecies,
                            vibe: selectedVibe
                        )
                        dismiss()
                    }
                    .disabled(nickname.isEmpty)
                }
            }
        }
    }
}

// MARK: - Photo Coming Soon View
struct PhotoComingSoonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "1B4332"))
                    .padding()
                
                Text("Photo Feature")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1B4332"))
                
                Text("Coming Soon!")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("We're working on adding photo functionality so you can document your plant's growth journey. Stay tuned!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "FDFBF7"), Color(hex: "E8F5E9")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Photo Feature")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MyRootmatesView()
}

