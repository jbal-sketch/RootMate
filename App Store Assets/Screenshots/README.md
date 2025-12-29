# App Store Screenshots

This folder is for storing your App Store screenshots.

## Required Screenshots

You need at least **1 screenshot**, but **3-5 are recommended**.

### Screenshot Requirements:
- **Size:** 1284 x 2778 pixels (iPhone 6.7" display) - **REQUIRED**
- **Alternative sizes accepted by App Store Connect:**
  - 1242 x 2688 pixels (iPhone 6.5" display)
  - 1284 x 2778 pixels (iPhone 6.7" display - newer models)
- **Format:** PNG or JPEG
- **Device:** iPhone 14 Pro Max, 15 Pro Max, 16 Pro Max, or 17 Pro Max

## Recommended Screenshots:

1. **My Rootmates Dashboard** - Home screen showing your plants
2. **Plant Detail View** - Individual plant profile with status
3. **Daily Chat View** - Plant personality message
4. **Settings View** (optional) - Settings screen
5. **QR Code View** (optional) - QR code feature

## How to Take Screenshots:

### Option 1: Using iPhone Simulator (Recommended)

**If you have iPhone 15 Pro Max or iPhone 16 Pro Max simulator:**
1. Open your app in Xcode
2. Select "iPhone 15 Pro Max" or "iPhone 16 Pro Max" simulator
3. Run the app (⌘ + R)
4. Navigate to each screen
5. Take screenshot: `⌘ + S` (saves to Desktop)
6. Move screenshots to this folder
7. Screenshots should already be 1290 x 2796 ✅

**If you only have iPhone 6.5" Display simulator (iPhone 16, etc.):**
1. Take screenshots as above (they'll be 1242 x 2688 or similar)
2. Use the resize script below to convert to 6.7" size

### Option 2: Resize Existing Screenshots

If your screenshots are not 1290 x 2796, use the resize script:

```bash
cd "App Store Assets/Screenshots"
./resize_to_6.7_inch.sh
```

This will create new files ending in `-6.7in.png` that are the correct size.

**Or manually resize using Preview (Mac):**
1. Open screenshot in Preview
2. Tools → Adjust Size
3. Set width: 1290, height: 2796
4. Uncheck "Scale proportionally" (or keep checked if you want to maintain aspect ratio and add padding)
5. Save

### Option 3: Using Real iPhone

1. Take screenshots on iPhone 14 Pro Max, 15 Pro Max, or 16 Pro Max
2. Transfer to Mac (AirDrop, email, or cable)
3. Move to this folder
4. Screenshots from these devices are already 1290 x 2796 ✅

## File Naming:

Suggested naming:
- `screenshot-1-dashboard.png`
- `screenshot-2-plant-detail.png`
- `screenshot-3-daily-chat.png`
- `screenshot-4-settings.png`
- `screenshot-5-qr-code.png`

## Notes:

- Screenshots should look polished and professional
- Remove any test data or placeholder text
- Show real, engaging content
- Make sure text is readable
- Avoid showing personal/sensitive information

