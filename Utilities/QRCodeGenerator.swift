//
//  QRCodeGenerator.swift
//  RootMate
//
//  Created on $(date)
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    /// Generates a QR code image from a string
    /// - Parameter string: The string to encode in the QR code
    /// - Parameter size: The desired size of the QR code image (default: 200x200)
    /// - Returns: A UIImage containing the QR code, or nil if generation fails
    static func generateQRCode(from string: String, size: CGFloat = 200) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Set the input message
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Get the output image
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        // Scale the image to the desired size
        let scale = size / outputImage.extent.size.width
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        // Convert to UIImage
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Generates a QR code image for a plant
    /// - Parameter plant: The plant to generate a QR code for
    /// - Parameter size: The desired size of the QR code image (default: 200x200)
    /// - Returns: A UIImage containing the QR code, or nil if generation fails
    static func generateQRCode(for plant: Plant, size: CGFloat = 200) -> UIImage? {
        // Create a unique identifier string for the plant
        // Format: rootmate://plant/{plantId}
        let qrString = "rootmate://plant/\(plant.id.uuidString)"
        return generateQRCode(from: qrString, size: size)
    }
}

