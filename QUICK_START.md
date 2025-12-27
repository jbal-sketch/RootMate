# Quick Start - Testing RootMate App

## 🚀 Fastest Way to Test (3 Steps)

### Step 1: Add Files to Xcode (2 minutes)

**In Xcode (which should already be open):**

1. **Find the Project Navigator** (left sidebar) - you should see folders like:
   - 📁 Models
   - 📁 ViewModels  
   - 📁 Network
   - 📁 Views
   - 📁 Utilities

2. **For each folder, add the new files:**

   **Models folder:**
   - Right-click on "Models" folder → "Add Files to RootMate..."
   - Navigate to `Models/Plant.swift` → Select it
   - ✅ Check "Add to targets: RootMate"
   - ✅ Uncheck "Copy items if needed" (file is already there)
   - Click "Add"
   - Repeat for `Models/User.swift`

   **ViewModels folder:**
   - Right-click "ViewModels" → "Add Files to RootMate..."
   - Select `ViewModels/PlantViewModel.swift`
   - ✅ Check "Add to targets: RootMate"
   - Click "Add"

   **Network folder:**
   - Right-click "Network" → "Add Files to RootMate..."
   - Select both `Network/WeatherService.swift` and `Network/AIService.swift`
   - ✅ Check "Add to targets: RootMate"
   - Click "Add"

   **Views folder:**
   - Right-click "Views" → "Add Files to RootMate..."
   - Select `Views/MyRoommatesView.swift`
   - ✅ Check "Add to targets: RootMate"
   - Click "Add"

   **Utilities folder:**
   - Right-click "Utilities" → "Add Files to RootMate..."
   - Select `Utilities/AISystemPrompts.swift`
   - ✅ Check "Add to targets: RootMate"
   - Click "Add"

### Step 2: Build the Project

1. **Select a simulator** at the top (next to the play button):
   - Click the device selector
   - Choose "iPhone 15 Pro" or any iPhone simulator

2. **Build:**
   - Press `⌘ + B` (Command + B)
   - Or: Product → Build
   - Wait for "Build Succeeded" ✅

### Step 3: Run the App

1. **Run:**
   - Press `⌘ + R` (Command + R)
   - Or: Product → Run
   - The simulator will launch and show your app!

## 🎯 What You Should See

The app will display:
- **"My Roommates"** title at the top
- **Header stats**: Total Roommates (3) and Hydrated count
- **Three plant cards:**
  - 🌿 **Fiona** (Fiddle Leaf Fig, Drama Queen 💅) - Thirsty
  - 🌿 **Basil** (Basil, Chill Roomie 🌿) - Hydrated  
  - 🌿 **Winston** (Snake Plant, Grumpy Senior 🌳) - Hydrated

## 🧪 Things to Test

- ✅ Tap any plant card to see details
- ✅ Tap "Water Plant" button to update status
- ✅ Tap the **+** button (top right) to add a new plant
- ✅ Scroll to see all plants
- ✅ Check the health streak indicators (flame icons)

## ❌ If You Get Build Errors

**Error: "Cannot find type 'Plant'"**
→ Make sure `Plant.swift` is added to the target (Step 1)

**Error: "Cannot find type 'PlantViewModel'"**
→ Make sure `PlantViewModel.swift` is added to the target

**Error: "Value of type 'Color' has no member 'hex'"**
→ This is normal - the Color extension is in MyRoommatesView.swift, make sure that file is added

**To check if files are added:**
1. Click on the RootMate project (blue icon) in Project Navigator
2. Select the "RootMate" target
3. Go to "Build Phases" tab
4. Expand "Compile Sources"
5. You should see all your .swift files listed there

## 🆘 Still Need Help?

If you're stuck, you can:
1. Close Xcode
2. Install XcodeGen: `brew install xcodegen`
3. Run: `xcodegen generate`
4. Reopen: `open RootMate.xcodeproj`

This will automatically add all files based on `project.yml`.

---

**That's it! You should be testing in under 5 minutes! 🎉**

