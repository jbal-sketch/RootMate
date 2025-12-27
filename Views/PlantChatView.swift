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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plant Header
                    HStack {
                        Text(plant.vibe.emoji)
                            .font(.system(size: 40))
                        VStack(alignment: .leading) {
                            Text(plant.nickname)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "1B4332"))
                            Text(plant.species)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
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
                // Generate Message Button
                Button(action: {
                    Task {
                        await generateMessage()
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Get Today's Message")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "1B4332"))
                    .cornerRadius(12)
                }
                .disabled(isLoading)
                .padding()
                .background(Color(hex: "FDFBF7"))
            }
        }
    }
    
    private func generateMessage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let generatedMessage = try await viewModel.generateDailyMessage(for: plant)
            message = generatedMessage
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
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

