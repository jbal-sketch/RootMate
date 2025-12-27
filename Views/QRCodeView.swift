//
//  QRCodeView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct QRCodeView: View {
    let plant: Plant
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(spacing: 32) {
                    // Custom header with dismiss button
                    HStack {
                        Spacer()
                        Button(action: onDismiss) {
                            Text("Done")
                                .foregroundColor(Color(hex: "1B4332"))
                                .fontWeight(.semibold)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(hex: "E8F5E9"))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "qrcode")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "1B4332"))
                }
                .padding(.bottom, 8)
                
                // Title
                VStack(spacing: 12) {
                    Text("QR Code Stickers")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "1B4332"))
                    
                    Text("Coming Soon!")
                        .font(.title2)
                        .foregroundColor(Color(hex: "D97706"))
                        .fontWeight(.semibold)
                }
                
                // Description
                VStack(spacing: 16) {
                    Text("Perfect for when others water your plants!")
                        .font(.headline)
                        .foregroundColor(Color(hex: "1B4332"))
                        .multilineTextAlignment(.center)
                    
                    Text("Print branded QR code stickers to stick on your plant pots. When friends, family, or plant sitters scan the code, they'll instantly access your plant's care instructions, personality, and chat history.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 32)
                
                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(
                        icon: "person.2.fill",
                        title: "Plant Sitters",
                        description: "Help others understand your plant's needs and personality"
                    )
                    
                    BenefitRow(
                        icon: "house.fill",
                        title: "House Guests",
                        description: "Visitors can scan and learn about your plants"
                    )
                    
                    BenefitRow(
                        icon: "info.circle.fill",
                        title: "Quick Access",
                        description: "Instant access to care instructions and watering history"
                    )
                    
                    BenefitRow(
                        icon: "heart.fill",
                        title: "Share the Love",
                        description: "Let others chat with your plants and see their personality"
                    )
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Preview Mockup
                VStack(spacing: 12) {
                    Text("Preview")
                        .font(.headline)
                        .foregroundColor(Color(hex: "1B4332"))
                    
                    // Mock QR code sticker
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "FDFBF7"))
                            .frame(width: 280, height: 280)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 12) {
                            Text(plant.nickname)
                                .font(.headline)
                                .foregroundColor(Color(hex: "1B4332"))
                            
                            // Mock QR code pattern
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 180, height: 180)
                                
                                // Simple QR-like pattern
                                VStack(spacing: 4) {
                                    HStack(spacing: 4) {
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                    }
                                    HStack(spacing: 4) {
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                        Rectangle().fill(Color(hex: "E8F5E9")).frame(width: 20, height: 20)
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                    }
                                    HStack(spacing: 4) {
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                        Rectangle().fill(Color.black).frame(width: 20, height: 20)
                                    }
                                }
                                .opacity(0.3)
                                
                                // Center logo placeholder
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "FDFBF7"))
                                        .frame(width: 50, height: 50)
                                    
                                    Text(PlantSpecies.emoji(for: plant.species))
                                        .font(.system(size: 30))
                                }
                            }
                            
                            Text(plant.species)
                                .font(.caption)
                                .foregroundColor(Color(hex: "1B4332").opacity(0.7))
                            
                            Text("RootMate")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "D97706"))
                        }
                    }
                    .padding(.vertical)
                }
                .padding()
                .background(Color(hex: "FDFBF7").opacity(0.5))
                .cornerRadius(16)
                .padding(.horizontal)
                
                    Spacer()
                        .frame(height: 20)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "FDFBF7"),
                        Color(hex: "E8F5E9")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "D97706"))
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "1B4332"))
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    QRCodeView(plant: Plant(
        userId: UUID(),
        nickname: "Fiona",
        species: "Fiddle Leaf Fig",
        vibe: .dramaQueen
    ), onDismiss: {})
    .padding()
    .background(Color(hex: "FDFBF7"))
}
