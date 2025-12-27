# RootMate iOS App

> **For Contributors**: This project is built to production standards by experienced iOS and HTML engineers. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before contributing to understand our development philosophy and standards.

## Project Structure

```
RootMate/
├── RootMateApp.swift          # Main app entry point
├── Views/                      # SwiftUI views
│   └── ContentView.swift
├── ViewModels/                 # View models for MVVM architecture
├── Models/                     # Data models
├── Network/                    # Network layer and API clients
├── Utilities/                  # Helper functions and utilities
├── Resources/                  # Additional resources (fonts, data files, etc.)
├── Assets.xcassets/            # Images, colors, and app icons
│   ├── AppIcon.appiconset/
│   └── AccentColor.colorset/
├── Info.plist                  # App configuration
├── marketing/                  # HTML marketing website
│   ├── index.html              # Landing page
│   ├── pages/                  # Additional pages (contact, privacy, terms)
│   ├── css/                    # Stylesheets
│   ├── js/                     # JavaScript files
│   └── images/                 # Marketing images
└── project.yml                 # XcodeGen configuration

```

## Setting Up in Xcode

### Option 1: Using XcodeGen (Recommended)

If you have [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed:

```bash
# Install XcodeGen (if not already installed)
brew install xcodegen

# Generate the Xcode project
xcodegen generate

# Open the project
open RootMate.xcodeproj
```

### Option 2: Manual Setup in Xcode

1. Open Xcode
2. Create a new project:
   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: RootMate
   - Interface: SwiftUI
   - Language: Swift
   - Storage: None (or Core Data if needed)

3. Replace the generated files with the files in this structure
4. Add all files to your Xcode project target:
   - Right-click on the project in the navigator
   - Select "Add Files to RootMate..."
   - Select all the folders and files
   - Make sure "Copy items if needed" is checked
   - Ensure your target is selected
5. Build and run!

## QR Code Feature

RootMate includes branded QR code stickers that link physical plants to their digital profiles in the app.

### How It Works

1. **Generate QR Code**: Users can generate a branded QR code sticker for each plant from the plant detail view
2. **Print & Apply**: The QR code can be printed on sticker paper and applied to plant pots
3. **Scan**: When someone scans the QR code:
   - **If RootMate app is installed**: Opens directly to the plant's detail view
   - **If app is not installed**: Shows a download prompt with App Store link

### Technical Details

- **QR Code Format**: `https://rootmate.app/plant/{plantId}`
- **Deep Link Scheme**: `rootmate://plant/{plantId}` (handled by the app)
- **Web Fallback**: `/marketing/pages/plant.html` handles redirects and download prompts
- **Configuration**: Update the domain in `QRCodeGenerator.swift` (currently set to `rootmate.app`)

### Setup

1. **Update Domain**: Before deploying, update the base URL in `Utilities/QRCodeGenerator.swift`:
   ```swift
   let baseURL = "https://yourdomain.com" // Update this
   ```

2. **Deploy Marketing Site**: The marketing site includes the plant redirect page and should be deployed to your domain

3. **URL Rewrites**: The `vercel.json` file includes a rewrite rule for `/plant/:plantId` → `/pages/plant.html?id=:plantId`

## Notes

- The app uses SwiftUI for the user interface
- Follow MVVM architecture pattern
- All source files are organized by feature/type
- The `marketing/` folder contains a complete HTML marketing website with landing pages
  - See `marketing/README.md` for marketing site details

