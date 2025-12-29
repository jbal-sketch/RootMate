//
//  PlantChatView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct PlantChatView: View {
    let plant: Plant
    @ObservedObject var viewModel: PlantViewModel
    @Environment(\.dismiss) var dismiss
    @State private var message: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var hasTodaysMessage: Bool = false
    @State private var showingSubscription = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plant Header
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            Text(PlantSpecies.emoji(for: plant.species))
                                .font(.system(size: 40))
                            Text(plant.vibe.emoji)
                                .font(.system(size: 16))
                                .offset(x: 4, y: 4)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plant.nickname)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "1B4332"))
                            Text(plant.species)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "5C6B5E"))
                            
                            // Last watering info
                            if let lastWatered = plant.lastWatered {
                                HStack(spacing: 4) {
                                    Image(systemName: "drop.fill")
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                    Text("Last watered: \(formatDate(lastWatered))")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "5C6B5E"))
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "drop")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                    Text("Never watered yet")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                    
                    // Message Display
                    if isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Your rootmate is thinking...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else if let error = errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            // Show subscribe button if subscription error
                            if error.contains("Subscribe") || error.contains("subscription") {
                                Button(action: {
                                    showingSubscription = true
                                }) {
                                    Text("Subscribe Now")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color(hex: "1B4332"))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    } else if !message.isEmpty {
                        // Message Bubble
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 8) {
                                Text(message)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(hex: "1B4332"))
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                
                                Text("Today")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity * 0.85, alignment: .trailing)
                        }
                    } else {
                        // Empty State
                        VStack(spacing: 16) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Color(hex: "1B4332").opacity(0.3))
                            
                            Text("No message yet")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Text("Tap the button below to get today's message from \(plant.nickname)!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
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
            .navigationTitle("Daily Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Generate/View Message Button
                Button(action: {
                    if hasTodaysMessage, let todaysMessage = viewModel.getTodaysMessage(for: plant.id) {
                        // Just load existing message
                        message = todaysMessage.message
                    } else {
                        // Generate new message
                        Task {
                            await generateMessage()
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: hasTodaysMessage ? "bubble.left.fill" : "sparkles")
                        Text(hasTodaysMessage ? "View Today's Message" : "Get Today's Message")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(hasTodaysMessage ? Color(hex: "1B4332").opacity(0.8) : Color(hex: "1B4332"))
                    .cornerRadius(12)
                }
                .disabled(isLoading)
                .padding()
                .background(Color(hex: "FDFBF7"))
            }
            .onAppear {
                checkForTodaysMessage()
            }
            .sheet(isPresented: $showingSubscription) {
                SubscriptionView()
            }
        }
    }
    
    private func checkForTodaysMessage() {
        hasTodaysMessage = viewModel.hasMessageForToday(for: plant.id)
        if hasTodaysMessage, let todaysMessage = viewModel.getTodaysMessage(for: plant.id) {
            message = todaysMessage.message
        }
    }
    
    private func generateMessage() async {
        // Check if message already exists for today
        if viewModel.hasMessageForToday(for: plant.id) {
            if let todaysMessage = viewModel.getTodaysMessage(for: plant.id) {
                message = todaysMessage.message
                hasTodaysMessage = true
                return
            }
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let generatedMessage = try await viewModel.generateDailyMessage(for: plant)
            message = generatedMessage
            hasTodaysMessage = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    PlantChatView(
        plant: Plant(
            userId: UUID(),
            nickname: "Fiona",
            species: "Fiddle Leaf Fig",
            vibe: .dramaQueen,
            status: .thirsty,
            lastWatered: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
            healthStreak: 5,
            location: "Edinburgh, Scotland"
        ),
        viewModel: PlantViewModel()
    )
}

