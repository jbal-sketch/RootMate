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
    /// Generates a QR code image from a string with error correction
    /// - Parameter string: The string to encode in the QR code
    /// - Parameter size: The desired size of the QR code image (default: 200x200)
    /// - Parameter errorCorrection: Error correction level (default: .M for 15% error correction)
    /// - Returns: A UIImage containing the QR code, or nil if generation fails
    static func generateQRCode(
        from string: String,
        size: CGFloat = 200,
        errorCorrection: String = "M"
    ) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Set the input message
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Set error correction level (L=7%, M=15%, Q=25%, H=30%)
        // Higher error correction allows for logo overlay and better scanning on printed materials
        filter.setValue(errorCorrection, forKey: "inputCorrectionLevel")
        
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
    
    /// Generates a branded QR code image for a plant with logo space and plant info
    /// - Parameter plant: The plant to generate a QR code for
    /// - Parameter size: The desired size of the final sticker image (default: 400x400)
    /// - Returns: A UIImage containing the branded QR code sticker, or nil if generation fails
    static func generateBrandedQRCode(for plant: Plant, size: CGFloat = 400) -> UIImage? {
        // Create a web URL that will redirect to the app if installed, or show download prompt
        // Format: https://rootmate.app/plant/{plantId}
        // This URL will:
        // 1. Try to open the RootMate app if installed (via rootmate://plant/{plantId})
        // 2. Show a download prompt if the app is not installed
        // Note: Update the domain (rootmate.app) to your actual marketing site domain
        let baseURL = "https://rootmate.app" // TODO: Update this to your actual domain
        let qrString = "\(baseURL)/plant/\(plant.id.uuidString)"
        
        // Generate base QR code with higher error correction for logo overlay
        guard let baseQRCode = generateQRCode(from: qrString, size: size * 0.6, errorCorrection: "H") else {
            return nil
        }
        
        // Create the branded sticker image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let brandedImage = renderer.image { context in
            let cgContext = context.cgContext
            
            // Brand colors
            let backgroundColor = UIColor(red: 0.992, green: 0.984, blue: 0.969, alpha: 1.0) // #FDFBF7
            let primaryColor = UIColor(red: 0.106, green: 0.263, blue: 0.196, alpha: 1.0) // #1B4332
            let accentColor = UIColor(red: 0.851, green: 0.467, blue: 0.024, alpha: 1.0) // #D97706
            let lightGreen = UIColor(red: 0.910, green: 0.961, blue: 0.914, alpha: 1.0) // #E8F5E9
            
            // Draw background with rounded corners
            let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
            let cornerRadius: CGFloat = size * 0.08
            
            cgContext.setFillColor(backgroundColor.cgColor)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.fill()
            
            // Draw decorative border
            cgContext.setStrokeColor(primaryColor.withAlphaComponent(0.3).cgColor)
            cgContext.setLineWidth(size * 0.01)
            path.stroke()
            
            // Draw inner border with accent color
            let innerRect = rect.insetBy(dx: size * 0.02, dy: size * 0.02)
            let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius * 0.8)
            cgContext.setStrokeColor(accentColor.withAlphaComponent(0.4).cgColor)
            cgContext.setLineWidth(size * 0.005)
            innerPath.stroke()
            
            // Draw QR code background (white square)
            let qrSize = size * 0.6
            let qrX = (size - qrSize) / 2
            let qrY = size * 0.15
            let qrRect = CGRect(x: qrX, y: qrY, width: qrSize, height: qrSize)
            
            cgContext.setFillColor(UIColor.white.cgColor)
            let qrBackgroundPath = UIBezierPath(roundedRect: qrRect, cornerRadius: size * 0.03)
            qrBackgroundPath.fill()
            
            // Draw QR code shadow
            cgContext.setShadow(offset: CGSize(width: 0, height: size * 0.01), blur: size * 0.02, color: UIColor.black.withAlphaComponent(0.2).cgColor)
            qrBackgroundPath.fill()
            cgContext.setShadow(offset: .zero, blur: 0, color: nil)
            
            // Draw QR code - keep it black for maximum scannability
            // QR codes need high contrast to scan properly
            cgContext.saveGState()
            cgContext.clip(to: qrRect)
            baseQRCode.draw(in: qrRect)
            cgContext.restoreGState()
            
            // Draw small logo/branding circle in center of QR code
            // Keep it small (15% of QR size) so it doesn't break scanning
            let logoSize = qrSize * 0.15
            let logoX = qrX + (qrSize - logoSize) / 2
            let logoY = qrY + (qrSize - logoSize) / 2
            let logoRect = CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize)
            
            // Logo background circle with slight transparency to maintain QR code readability
            cgContext.setFillColor(backgroundColor.withAlphaComponent(0.95).cgColor)
            cgContext.fillEllipse(in: logoRect)
            
            // Logo border
            cgContext.setStrokeColor(primaryColor.cgColor)
            cgContext.setLineWidth(size * 0.006)
            cgContext.strokeEllipse(in: logoRect)
            
            // Draw plant emoji in logo circle
            let plantEmoji = PlantSpecies.emoji(for: plant.species)
            let emojiSize = logoSize * 0.7
            let emojiFont = UIFont.systemFont(ofSize: emojiSize)
            let emojiAttributes: [NSAttributedString.Key: Any] = [
                .font: emojiFont
            ]
            let emojiString = NSAttributedString(string: plantEmoji, attributes: emojiAttributes)
            let emojiSize_actual = emojiString.size()
            let emojiX = logoX + (logoSize - emojiSize_actual.width) / 2
            let emojiY = logoY + (logoSize - emojiSize_actual.height) / 2
            emojiString.draw(at: CGPoint(x: emojiX, y: emojiY))
            
            // Draw plant nickname above QR code
            let nicknameY = qrY - size * 0.08
            let nicknameFont = UIFont.boldSystemFont(ofSize: size * 0.06)
            let nicknameAttributes: [NSAttributedString.Key: Any] = [
                .font: nicknameFont,
                .foregroundColor: primaryColor
            ]
            let nicknameString = NSAttributedString(string: plant.nickname, attributes: nicknameAttributes)
            let nicknameSize = nicknameString.size()
            let nicknameX = (size - nicknameSize.width) / 2
            nicknameString.draw(at: CGPoint(x: nicknameX, y: nicknameY))
            
            // Draw species name below QR code
            let speciesY = qrY + qrSize + size * 0.05
            let speciesFont = UIFont.systemFont(ofSize: size * 0.04)
            let speciesAttributes: [NSAttributedString.Key: Any] = [
                .font: speciesFont,
                .foregroundColor: primaryColor.withAlphaComponent(0.7)
            ]
            let speciesString = NSAttributedString(string: plant.species, attributes: speciesAttributes)
            let speciesSize = speciesString.size()
            let speciesX = (size - speciesSize.width) / 2
            speciesString.draw(at: CGPoint(x: speciesX, y: speciesY))
            
            // Draw "RootMate" branding at bottom
            let brandY = size - size * 0.12
            let brandFont = UIFont.boldSystemFont(ofSize: size * 0.035)
            let brandAttributes: [NSAttributedString.Key: Any] = [
                .font: brandFont,
                .foregroundColor: accentColor
            ]
            let brandString = NSAttributedString(string: "RootMate", attributes: brandAttributes)
            let brandSize = brandString.size()
            let brandX = (size - brandSize.width) / 2
            brandString.draw(at: CGPoint(x: brandX, y: brandY))
        }
        
        return brandedImage
    }
    
    /// Generates a QR code image for a plant (legacy method for backward compatibility)
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

