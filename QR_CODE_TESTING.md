# QR Code Testing Guide

This guide covers how to test QR code generation, scanning, deep linking, and the web fallback page.

## 🎯 Overview

RootMate QR codes work in two scenarios:
1. **App Installed**: Opens directly to the plant's detail view
2. **App Not Installed**: Shows a download prompt with App Store link

## 📱 Testing QR Code Generation in the App

### Step 1: Generate a QR Code

1. **Run the app** in Xcode Simulator or on a device
2. **Tap on any plant** (e.g., Fiona, Basil, or Winston) to open Plant Detail View
3. **Scroll down** to find the QR code button (or look for "View QR Code" action)
4. **Tap the QR code button** to open the QR Code view
5. **Verify the QR code displays** with:
   - Plant nickname at the top
   - Branded QR code with plant emoji in center
   - Plant species name below
   - "RootMate" branding at the bottom
   - Brand colors (dark green, terracotta, cream)

### Step 2: Test Share & Print

1. In the QR Code view, tap **"Share & Print"** button
2. Verify the iOS share sheet appears
3. Test sharing to:
   - **Files app** (to save the image)
   - **Photos** (to save to camera roll)
   - **AirDrop** (to another device)
   - **Print** (if printer is available)

### Step 3: Test Save to Photos

1. Tap **"Save to Photos"** button
2. Verify the image is saved to your photo library
3. Open Photos app and confirm the QR code image is there

## 🔗 Testing Deep Linking (App Installed)

### Method 1: Using Safari in Simulator

1. **Run the app** in Xcode Simulator
2. **Open Safari** in the simulator
3. **Type in the address bar**: `rootmate://plant/{plantId}`
   - Replace `{plantId}` with an actual plant ID from your app
   - To find a plant ID: Add a print statement in the app or check the console
4. **Press Enter**
5. **Verify**: The app should open and navigate to that plant's detail view

### Method 2: Using QR Code Scanner (Recommended)

1. **Generate a QR code** in the app (see Step 1 above)
2. **Save the QR code** to Photos
3. **Open Camera app** on a physical iPhone (or use a QR scanner app)
4. **Scan the QR code** from the saved image
5. **Verify**: 
   - If app is installed: Opens directly to plant detail view
   - If app is not installed: Opens web page with download prompt

### Method 3: Using Xcode Scheme URL

1. In Xcode, go to **Product → Scheme → Edit Scheme...**
2. Select **Run** → **Arguments** tab
3. Under **Launch Arguments**, add:
   ```
   -rootmate://plant/{plantId}
   ```
4. Run the app
5. The app should open and navigate to the plant

### Method 4: Using Terminal (Simulator)

```bash
# Open URL in simulator
xcrun simctl openurl booted "rootmate://plant/{plantId}"
```

Replace `{plantId}` with an actual UUID from your plants.

## 🌐 Testing Web Fallback (App Not Installed)

### Step 1: Set Up Local Web Server

You need to serve the marketing site locally to test the web fallback:

#### Option A: Using Python (Easiest)

```bash
# Navigate to the marketing folder
cd marketing

# Start a local server (Python 3)
python3 -m http.server 8000

# Or Python 2
python -m SimpleHTTPServer 8000
```

The site will be available at: `http://localhost:8000`

#### Option B: Using Node.js (http-server)

```bash
# Install http-server globally
npm install -g http-server

# Navigate to marketing folder
cd marketing

# Start server
http-server -p 8000
```

#### Option C: Using Vercel CLI (If Deployed)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy to preview
vercel
```

### Step 2: Update QR Code URL for Testing

For local testing, you'll need to temporarily update the base URL in `QRCodeGenerator.swift`:

```swift
// In Utilities/QRCodeGenerator.swift, line ~59
let baseURL = "http://localhost:8000" // For local testing
// Or use your deployed domain: "https://rootmate.app"
```

**Important**: Remember to change this back to your production domain before releasing!

### Step 3: Test Web Fallback Page

1. **Generate a QR code** with the local URL
2. **Open the QR code URL** in a browser (not on a device with the app installed)
   - Example: `http://localhost:8000/plant/{plantId}`
3. **Verify the page shows**:
   - Loading state initially ("Opening RootMate...")
   - After 2 seconds: Download prompt appears
   - App Store download button
   - Feature highlights
   - "Open in RootMate App" button

### Step 4: Test App Detection

1. **With app installed**: Scan QR code → Should open app immediately
2. **Without app installed**: Scan QR code → Should show download prompt after 2 seconds
3. **Test the "Open in RootMate App" button**: Should attempt to open the app

## 🧪 Testing Checklist

### QR Code Generation
- [ ] QR code displays with plant nickname
- [ ] QR code displays with plant species
- [ ] QR code has plant emoji in center
- [ ] QR code has "RootMate" branding
- [ ] Brand colors are correct (dark green, terracotta, cream)
- [ ] QR code is high resolution (400x400)
- [ ] Share & Print button works
- [ ] Save to Photos button works

### Deep Linking (App Installed)
- [ ] Direct URL scheme opens app: `rootmate://plant/{id}`
- [ ] Web URL redirects to app: `https://rootmate.app/plant/{id}`
- [ ] App navigates to correct plant detail view
- [ ] Plant information displays correctly

### Web Fallback (App Not Installed)
- [ ] Web page loads at `/plant/{id}`
- [ ] Loading state appears initially
- [ ] Download prompt appears after 2 seconds
- [ ] App Store button is visible
- [ ] Feature highlights display correctly
- [ ] "Open in RootMate App" button works
- [ ] Page is mobile-responsive

### Edge Cases
- [ ] Invalid plant ID shows appropriate error
- [ ] Missing plant ID shows download prompt
- [ ] QR code scans correctly from printed material
- [ ] QR code works with partial damage (error correction)

## 🔍 Finding Plant IDs for Testing

### Method 1: Add Debug Print

In `MyRootmatesView.swift` or `PlantDetailView.swift`, add:

```swift
.onAppear {
    print("Plant ID: \(plant.id.uuidString)")
}
```

### Method 2: Check Console Logs

When you tap a plant, check Xcode console for any logged IDs.

### Method 3: Add to QR Code View

Temporarily display the plant ID in the QR Code view for testing:

```swift
Text("Plant ID: \(plant.id.uuidString)")
    .font(.caption)
    .foregroundColor(.secondary)
```

## 🐛 Troubleshooting

### QR Code Doesn't Generate
- **Check**: Ensure `QRCodeGenerator.swift` is included in the target
- **Check**: Verify CoreImage framework is available
- **Check**: Console for any error messages

### Deep Link Doesn't Work
- **Check**: `Info.plist` has `CFBundleURLTypes` with `rootmate` scheme
- **Check**: URL format is exactly: `rootmate://plant/{uuid}`
- **Check**: Plant ID is a valid UUID
- **Check**: App is actually installed on the device

### Web Page Doesn't Load
- **Check**: Local server is running (if testing locally)
- **Check**: URL rewrite rules in `vercel.json` (if deployed)
- **Check**: Browser console for JavaScript errors
- **Check**: Network tab for failed requests

### App Doesn't Open from Web Page
- **Check**: JavaScript is enabled in browser
- **Check**: URL scheme is correct: `rootmate://plant/{id}`
- **Check**: App is installed on the device
- **Check**: Browser allows app links (some browsers block custom schemes)

## 📝 Quick Test Commands

### Test URL Scheme Directly (Simulator)
```bash
# Replace {plantId} with actual UUID
xcrun simctl openurl booted "rootmate://plant/{plantId}"
```

### Test Web URL (Browser)
```
http://localhost:8000/plant/{plantId}
```

### Generate Test QR Code Image
1. Use any QR code generator online
2. Enter URL: `rootmate://plant/{plantId}` or `https://rootmate.app/plant/{plantId}`
3. Download and test scanning

## 🚀 Production Testing

Before releasing:

1. **Update domain** in `QRCodeGenerator.swift` to production URL
2. **Update App Store link** in `plant.html` to actual App Store URL
3. **Deploy marketing site** to production domain
4. **Test on real devices** (both with and without app installed)
5. **Test printed QR codes** (print and scan from physical paper)
6. **Test error correction** (partially cover QR code and verify it still scans)

---

**Happy Testing! 🌿**

