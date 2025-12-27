//
//  QRCodeView.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI

struct QRCodeView: View {
    let plant: Plant
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Plant QR Code")
                .font(.headline)
                .foregroundColor(Color(hex: "1B4332"))
            
            if let qrImage = qrCodeImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
            } else {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            Text("Scan to view plant details")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .onAppear {
            generateQRCode()
        }
    }
    
    private func generateQRCode() {
        qrCodeImage = QRCodeGenerator.generateQRCode(for: plant, size: 200)
    }
}

#Preview {
    QRCodeView(plant: Plant(
        nickname: "Fiona",
        species: "Fiddle Leaf Fig",
        vibe: .dramaQueen
    ))
    .padding()
    .background(Color(hex: "FDFBF7"))
}

