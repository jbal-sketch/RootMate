# Testing Guide for RootMate App

## Quick Start

The Xcode project has been opened. To test the app, you need to:

### Step 1: Add New Files to Xcode Project

The following new files need to be added to your Xcode project:

1. **Models/**
   - `Plant.swift`
   - `User.swift`

2. **ViewModels/**
   - `PlantViewModel.swift`

3. **Network/**
   - `WeatherService.swift`
   - `AIService.swift`

4. **Views/**
   - `MyRootmatesView.swift`

5. **Utilities/**
   - `AISystemPrompts.swift`

**How to add files in Xcode:**
1. In Xcode, right-click on each folder (Models, ViewModels, Network, Views, Utilities)
2. Select "Add Files to RootMate..."
3. Navigate to and select the corresponding `.swift` file
4. Make sure:
   - ✅ "Copy items if needed" is **unchecked** (files are already in the project directory)
   - ✅ "Add to targets: RootMate" is **checked**
5. Click "Add"

**OR use the faster method:**
1. In Xcode Project Navigator, select the RootMate project (blue icon at top)
2. Drag and drop the files from Finder into the appropriate folders in Xcode
3. In the dialog, ensure "Add to targets: RootMate" is checked

### Step 2: Build the Project

1. In Xcode, select a simulator (e.g., "iPhone 15 Pro" or "iPhone 15")
2. Press `⌘ + B` (or Product → Build) to build the project
3. Fix any build errors if they appear

### Step 3: Run the App

1. Press `⌘ + R` (or Product → Run) to launch the app in the simulator
2. The app should open showing the "My Rootmates" dashboard

### Step 4: Test Features

**Dashboard Features to Test:**
- ✅ View the list of sample plants (Fiona, Basil, Winston)
- ✅ See plant status badges (Hydrated/Thirsty)
- ✅ Check health streak indicators
- ✅ Tap on a plant card to see details
- ✅ Test the "Water Plant" button
- ✅ Test the "Add Plant" button (+ icon in top right)
- ✅ Verify the gradient background and styling

**Expected Behavior:**
- Dashboard shows 3 sample plants with different vibes
- Status updates based on last watered date
- Health streaks increment when plants are watered
- Plant detail view shows full information
- Add plant flow allows creating new plants

### Troubleshooting

**Build Errors:**
- If you see "Cannot find type 'Plant'", make sure `Plant.swift` is added to the target
- If you see "Cannot find type 'PlantViewModel'", make sure `PlantViewModel.swift` is added
- Check that all files are included in the "Compile Sources" build phase

**Runtime Issues:**
- The app uses sample data, so it should work without API keys
- Weather and AI features require API keys (OpenAI, Open-Meteo) but won't crash without them

### Alternative: Regenerate Project with XcodeGen

If you prefer to use XcodeGen:

```bash
# Install XcodeGen
brew install xcodegen

# Regenerate the Xcode project
xcodegen generate

# Open the project
open RootMate.xcodeproj
```

This will automatically include all Swift files based on `project.yml`.

## What to Expect

The app should display:
- A beautiful gradient background (Cream to light green)
- Header showing "Total Rootmates" and "Hydrated" counts
- Three plant cards:
  - **Fiona** (Fiddle Leaf Fig, Drama Queen 💅) - Thirsty
  - **Basil** (Basil, Chill Roomie 🌿) - Hydrated
  - **Winston** (Snake Plant, Grumpy Senior 🌳) - Hydrated
- Each card shows status badge and health streak flame icon

Enjoy testing! 🌿

