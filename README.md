# RootMate iOS App

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

## Notes

- The app uses SwiftUI for the user interface
- Follow MVVM architecture pattern
- All source files are organized by feature/type
- The `marketing/` folder contains a complete HTML marketing website with landing pages
  - See `marketing/README.md` for marketing site details

