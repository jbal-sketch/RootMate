//
//  MyRootmatesView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct MyRootmatesView: View {
    @StateObject private var viewModel = PlantViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingAddPlant = false
    @State private var showingSettings = false
    @State private var selectedPlantId: UUID?
    
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
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "1B4332"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPlant = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "1B4332"))
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
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
                // Configure AI if API key is available
                if let apiKey = UserDefaults.standard.string(forKey: "gemini_api_key"), !apiKey.isEmpty {
                    viewModel.configureAI(apiKey: apiKey)
                }
            }
            .onChange(of: appState.selectedPlantId) { newPlantId in
                if let plantId = newPlantId {
                    selectedPlantId = plantId
                    appState.selectedPlantId = nil // Reset after handling
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
                        .foregroundColor(.secondary)
                    Text("\(viewModel.plants.count)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "1B4332"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Hydrated")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(hydratedCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color.white.opacity(0.8))
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
                    RootmateCard(plant: plant, viewModel: viewModel)
                }
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
}

// MARK: - Rootmate Card
struct RootmateCard: View {
    let plant: Plant
    @ObservedObject var viewModel: PlantViewModel
    @State private var showingDetails = false
    
    var body: some View {
        Button(action: {
            showingDetails = true
        }) {
            HStack(spacing: 16) {
                // Plant Icon & Status
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(plant.vibe.emoji)
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
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            PlantDetailView(plantId: plant.id, viewModel: viewModel)
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

// MARK: - Plant Detail View
struct PlantDetailView: View {
    let plantId: UUID
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingEditPlant = false
    @State private var showingChat = false
    @State private var showingQRCode = false
    
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
                                Text(plant.vibe.emoji)
                                    .font(.system(size: 50))
                                VStack(alignment: .leading) {
                                    Text(plant.nickname)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "1B4332"))
                                    Text(plant.species)
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Text(plant.vibe.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .italic()
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
                    NavigationView {
                        QRCodeView(plant: plant)
                            .navigationTitle("Plant QR Code")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Done") {
                                        showingQRCode = false
                                    }
                                }
                            }
                    }
                }
            }
            .sheet(isPresented: $showingChat) {
                if let plant = plant {
                    PlantChatView(plant: plant, viewModel: viewModel)
                }
            }
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
            
            HStack {
                Text(plant.status.emoji)
                    .font(.title)
                Text(plant.status.rawValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            
            if let lastWatered = plant.lastWatered {
                let daysSince = Calendar.current.dateComponents([.day], from: lastWatered, to: Date()).day ?? 0
                Text("Last watered \(daysSince) day\(daysSince == 1 ? "" : "s") ago")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading)
            }
        }
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
                // TODO: Open camera for photo upload
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
    @State private var selectedSpecies = "Fiddle Leaf Fig"
    @State private var selectedVibe: PlantVibe = .dramaQueen
    @State private var cityLocation = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Plant Details") {
                    TextField("Nickname", text: $nickname)
                    Picker("Species", selection: $selectedSpecies) {
                        ForEach(PlantSpecies.commonSpecies, id: \.self) { species in
                            HStack {
                                Text(PlantSpecies.emoji(for: species))
                                Text(species)
                            }.tag(species)
                        }
                    }
                    Picker("Vibe", selection: $selectedVibe) {
                        ForEach(PlantVibe.allCases, id: \.self) { vibe in
                            HStack {
                                Text(vibe.emoji)
                                Text(vibe.rawValue)
                            }.tag(vibe)
                        }
                    }
                }
                
                Section("Location") {
                    TextField("City (e.g., Edinburgh, Scotland)", text: $cityLocation)
                        .autocapitalization(.words)
                    
                    Text("Enter your city for weather-aware plant messages")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
                            qrCode: plantId.uuidString, // Generate QR code identifier
                            location: cityLocation.isEmpty ? nil : cityLocation
                        )
                        viewModel.addPlant(newPlant)
                        dismiss()
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
    @State private var cityLocation: String
    
    init(plant: Plant, viewModel: PlantViewModel) {
        self.plant = plant
        self.viewModel = viewModel
        _nickname = State(initialValue: plant.nickname)
        _selectedSpecies = State(initialValue: plant.species)
        _selectedVibe = State(initialValue: plant.vibe)
        _cityLocation = State(initialValue: plant.location ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Plant Details") {
                    TextField("Nickname", text: $nickname)
                    Picker("Species", selection: $selectedSpecies) {
                        ForEach(PlantSpecies.commonSpecies, id: \.self) { species in
                            HStack {
                                Text(PlantSpecies.emoji(for: species))
                                Text(species)
                            }.tag(species)
                        }
                    }
                    Picker("Vibe", selection: $selectedVibe) {
                        ForEach(PlantVibe.allCases, id: \.self) { vibe in
                            HStack {
                                Text(vibe.emoji)
                                Text(vibe.rawValue)
                            }.tag(vibe)
                        }
                    }
                }
                
                Section("Location") {
                    TextField("City (e.g., Edinburgh, Scotland)", text: $cityLocation)
                        .autocapitalization(.words)
                    
                    Text("Enter your city for weather-aware plant messages")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
                            vibe: selectedVibe,
                            location: cityLocation.isEmpty ? nil : cityLocation
                        )
                        dismiss()
                    }
                    .disabled(nickname.isEmpty)
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

