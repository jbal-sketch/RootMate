# App Store Submission Guide for RootMate

This is a complete step-by-step guide for submitting RootMate to the App Store. Follow these steps in order.

## Prerequisites Checklist

Before you begin, make sure you have:
- [ ] A Mac with Xcode installed (latest version recommended)
- [ ] An Apple ID (your personal Apple account)
- [ ] A credit card or payment method ready
- [ ] Your app is fully tested and working
- [ ] All required assets (app icon, screenshots, description) prepared

---

## Step 1: Enroll in Apple Developer Program

**Cost:** $99 USD per year

1. **Go to Apple Developer website:**
   - Visit: https://developer.apple.com/programs/
   - Click "Enroll" button

   **⚠️ If the "Enroll" button just refreshes the page:**
   - **RECOMMENDED:** Use the "Apple Developer" app on your iPhone, iPad, or Mac instead
   - Download from App Store/Mac App Store, then enroll through the app
   - This is Apple's preferred method and more reliable
   - See `ENROLLMENT_TROUBLESHOOTING.md` for more solutions

2. **Sign in with your Apple ID:**
   - Use the same Apple ID you use for iCloud, App Store purchases, etc.
   - **Important:** Use an email-based Apple ID (not phone number)
   - If you don't have one, create it at appleid.apple.com first

3. **Complete enrollment:**
   - Fill out your personal/company information
   - Choose "Individual" or "Organization" (Individual is simpler for first-time developers)
   - Provide payment information ($99/year)
   - Wait for approval (usually 24-48 hours, can take up to 2 weeks)

4. **Verify enrollment:**
   - Once approved, you'll receive an email
   - Log in to https://developer.apple.com/account/
   - You should see "Active" status

**⏱️ Time:** 1-2 weeks (mostly waiting for approval)

---

## Step 2: Prepare Your App Assets

Before submitting, you need these assets ready:

### Required Assets:

1. **App Icon:**
   - Size: 1024x1024 pixels
   - Format: PNG or JPEG (no transparency)
   - Location: Already in `Assets.xcassets/AppIcon.appiconset/`
   - **Action:** Make sure you have a 1024x1024 icon in the AppIcon set

2. **App Screenshots:**
   - **iPhone 6.7" Display (REQUIRED):**
     - Required: At least 1 screenshot
     - Recommended: 3-5 screenshots
     - Size: **1284 x 2778 pixels** (or 1242 x 2688 pixels for 6.5" display)
     - **Note:** App Store Connect accepts: 1242×2688, 1284×2778 (portrait) or their landscape equivalents
     - **Note:** If your simulator only shows iPhone 6.5" Display, you can resize screenshots using the script in `App Store Assets/Screenshots/resize_to_6.7_inch.sh`
   - **iPhone 6.5" Display (optional):**
     - Size: 1242 x 2688 pixels
     - Apple can auto-generate these from your 6.7" screenshots
   - **iPhone 5.5" Display (optional):**
     - Size: 1242 x 2208 pixels
     - Apple can auto-generate these from your 6.7" screenshots
   - Format: PNG or JPEG
   - **Tip:** Take screenshots on a real device or simulator showing your app's key features

3. **App Description:**
   - Name: "RootMate" (or your preferred name, max 30 characters)
   - Subtitle: Optional, max 30 characters
   - Description: Write a compelling description (max 4000 characters)
   - Keywords: Comma-separated, max 100 characters
   - Promotional Text: Optional, can be updated without resubmission (max 170 characters)

4. **Privacy Information:**
   - Privacy Policy URL (required if your app collects data)
   - App Privacy details (what data you collect, how you use it)

5. **Support URL:**
   - A website where users can get help
   - Can be your marketing site: https://rootmate.app

6. **Marketing URL (Optional):**
   - Your marketing website: https://rootmate.app

### Quick Asset Checklist:
- [ ] 1024x1024 app icon
- [ ] 3-5 screenshots for iPhone 6.7" display
- [ ] App description written
- [ ] Privacy policy URL ready
- [ ] Support URL ready

---

## Step 3: Configure Your App in Xcode

### 3.1 Open Your Project

1. Open Xcode
2. Open `RootMate.xcodeproj` (or generate it with `xcodegen generate` if needed)

### 3.2 Set Up Signing & Capabilities

1. **Select your project** in the navigator (top item, blue icon)
2. **Select the "RootMate" target** (under TARGETS)
3. **Go to "Signing & Capabilities" tab**

4. **Configure Signing:**
   - Check "Automatically manage signing"
   - Select your **Team** (should show your Apple Developer account)
   - If you don't see your team:
     - Click "Add Account..."
     - Sign in with your Apple ID
     - Wait for Xcode to fetch your developer account

   **⚠️ If you see "Your team has no devices" error:**
   - **This is normal for first-time setup!** You don't need a physical device for App Store builds
   - **Option 1 (Recommended):** Ignore the warning for now - you can still create App Store builds
   - **Option 2:** Add a device (see troubleshooting section below)
   - **Option 3:** Select "Any iOS Device" as your build destination (top toolbar) - this works for App Store builds
   - The error won't prevent you from archiving and uploading to App Store Connect

5. **Verify Bundle Identifier:**
   - Should be: `com.rootmate.RootMate`
   - This must be unique and match what you'll register in App Store Connect

6. **Check Capabilities:**
   - Your app uses:
     - Push Notifications (if applicable)
     - Background Modes (for notifications)
   - Xcode should automatically add these if needed

### 3.3 Update Version and Build Numbers

1. Still in the target settings, go to **"General" tab**
2. **Version:** Set to `1.0` (or your first version)
3. **Build:** Set to `1` (increment this for each submission)
   - Format: Increment by 1 each time (1, 2, 3, etc.)

**Note:** You can also update these in `Info.plist`:
- `CFBundleShortVersionString` = Version (e.g., "1.0")
- `CFBundleVersion` = Build number (e.g., "1")

### 3.4 Verify App Icon

1. Go to `Assets.xcassets` → `AppIcon`
2. Make sure you have a **1024x1024** icon in the AppIcon set
3. If missing, add your 1024x1024 icon

---

## Step 4: Create App in App Store Connect

App Store Connect is Apple's portal for managing your apps.

### 4.1 Access App Store Connect

1. Go to: https://appstoreconnect.apple.com
2. Sign in with your **Apple Developer account** (same Apple ID from Step 1)

### 4.2 Create New App

1. Click **"My Apps"** in the top navigation
2. Click the **"+"** button (top left)
3. Select **"New App"**

4. **Fill in App Information:**
   - **Platform:** iOS
   - **Name:** "RootMate" (or your preferred name)
     - Must be unique, max 30 characters
     - Users will see this in the App Store
   - **Primary Language:** English (or your language)
   - **Bundle ID:** Select `com.rootmate.RootMate`
     - If it doesn't exist, you'll need to create it first (see below)
   - **SKU:** A unique identifier (e.g., "rootmate-001")
     - This is internal, users don't see it
   - **User Access:** Full Access (unless you have a team)

5. Click **"Create"**

### 4.3 Create Bundle ID (if needed)

If your Bundle ID doesn't exist:

1. Go to: https://developer.apple.com/account/resources/identifiers/list
2. Click **"+"** button
3. Select **"App IDs"** → **"Continue"**
4. Select **"App"** → **"Continue"**
5. Fill in:
   - **Description:** RootMate App
   - **Bundle ID:** `com.rootmate.RootMate`
     - Or select "Explicit" and enter it
6. **Enable Capabilities** (if needed):
   - Push Notifications
   - Associated Domains (if using deep links)
7. Click **"Continue"** → **"Register"**

---

## Step 5: Configure App Information in App Store Connect

Now you'll fill in all the details about your app.

### 5.1 App Information

1. In App Store Connect, select your app
2. Go to **"App Information"** (left sidebar)
3. Fill in:
   - **Category:** Select Primary (e.g., "Lifestyle" or "Utilities")
   - **Subcategory:** Optional
   - **Content Rights:** If you have content rights, check the box

### 5.2 Pricing and Availability

1. Go to **"Pricing and Availability"**
2. Set:
   - **Price:** Free (or set a price)
   - **Availability:** All countries (or select specific ones)

### 5.3 App Privacy

1. Go to **"App Privacy"**
2. Click **"Get Started"** or **"Edit"**
3. Answer questions about data collection:
   - Does your app collect data? (User content, usage data, etc.)
   - How is data used? (App functionality, analytics, etc.)
   - Is data linked to user identity?
   - Is data used for tracking?
4. **Important:** Be honest and accurate. Apple reviews this.

### 5.4 Prepare for Submission

1. Go to **"1.0 Prepare for Submission"** (or your version number)
2. This is where you'll add screenshots, description, etc.

---

## Step 6: Add App Store Listing Information

### 6.1 Screenshots

1. In "Prepare for Submission", scroll to **"Screenshots"**
2. **For iPhone 6.7" Display (REQUIRED):**
   - Click the screenshot area
   - Upload your screenshots (**1284 x 2778 pixels** or 1242 x 2688 pixels)
   - **If your screenshots are a different size:** Use the resize script in `App Store Assets/Screenshots/resize_to_6.7_inch.sh` to convert them
   - Add 3-5 screenshots showing key features
   - Drag to reorder (first one is most important)

3. **For other sizes (optional but recommended):**
   - Add screenshots for iPhone 6.5" and 5.5" displays
   - Or let Apple generate them from your 6.7" screenshots

### 6.2 App Preview (Optional)

- You can add a short video (15-30 seconds) showing your app
- This appears before screenshots in the App Store

### 6.3 Description

1. Scroll to **"Description"**
2. Write a compelling description:
   - First 2-3 lines are most important (shown in search results)
   - Highlight key features
   - Use bullet points for readability
   - Max 4000 characters

**Example structure:**
```
RootMate helps you care for your plants with AI-powered guidance and personalized reminders.

Key Features:
• Track all your plants in one place
• Get AI-powered care advice
• Receive watering and care reminders
• Generate QR codes for your plants
• Connect with a community of plant lovers

Perfect for both beginners and experienced plant parents.
```

### 6.4 Keywords

1. Scroll to **"Keywords"**
2. Enter comma-separated keywords (no spaces after commas)
3. Max 100 characters
4. **Tip:** Use relevant terms users might search for
   - Example: "plants,plant care,gardening,houseplants,reminders"

### 6.5 Support URL

1. Enter your support website
   - Example: `https://rootmate.app` or `https://rootmate.app/pages/contact.html`

### 6.6 Marketing URL (Optional)

1. Enter your marketing website
   - Example: `https://rootmate.app`

### 6.7 Privacy Policy URL

1. **Required** if your app collects any user data
2. Enter URL to your privacy policy
   - Example: `https://rootmate.app/pages/privacy.html`
3. Make sure this page exists and is accessible

### 6.8 App Icon

1. Scroll to **"App Icon"**
2. Upload your 1024x1024 icon
3. Must match the icon in your app

### 6.9 Version Information

1. **Version:** 1.0 (should match your app)
2. **Copyright:** © 2024 Your Name (or company)
3. **What's New in This Version:** Description of features (for first version, describe the app)

---

## Step 7: Build and Archive Your App

Now you'll create a build to upload to App Store Connect.

### 7.1 Clean and Build

1. In Xcode, select **"Product"** → **"Clean Build Folder"** (Shift+Cmd+K)
2. Select **"Any iOS Device"** as the destination (not a simulator)
   - In the device selector (top toolbar), choose "Any iOS Device"

### 7.2 Create Archive

1. **Before archiving, ensure:**
   - **"Any iOS Device"** is selected as build destination (top toolbar)
   - Your project is using **Release** configuration for Archive (this is default)
   - Automatic signing is enabled for the **Release** configuration

2. Select **"Product"** → **"Archive"**
3. Xcode will:
   - Build your app
   - Create an archive
   - Open the Organizer window

**If you get errors:**
- Fix any code errors
- Make sure signing is configured correctly
- Check that all dependencies are resolved

**⚠️ If you get "Your team has no devices" error during archive:**

This happens because Xcode tries to validate signing for all configurations. Here's how to fix it:

**Solution 1: Configure Signing for Release Only (Recommended for App Store)**

1. In Xcode, select your project → "RootMate" target
2. Go to **"Signing & Capabilities"** tab
3. You'll see signing settings for both **Debug** and **Release** configurations
4. **For Debug configuration:**
   - You can either:
     - **Option A:** Uncheck "Automatically manage signing" for Debug (if you're only doing App Store builds)
     - **Option B:** Keep it checked but ignore the warning (it won't affect Release/Archive)
5. **For Release configuration:**
   - ✅ Make sure "Automatically manage signing" is **checked**
   - ✅ Select your Team
   - This is what matters for App Store builds

6. Try archiving again (Product → Archive)

**Solution 2: Add a Device (Quick Fix)**

If you have an iPhone/iPad available:
1. Connect your device via USB
2. Unlock device and trust the computer
3. In Xcode: Window → Devices and Simulators (Shift+Cmd+2)
4. Your device will be registered automatically
5. Try archiving again

**Solution 3: Use Command Line Archive (Bypasses Some Checks)**

If the GUI keeps failing, you can archive via command line:

**Important:** The project file has `CODE_SIGN_STYLE = Manual` which disables automatic signing. Use the `-allowProvisioningUpdates` flag to enable it during build.

1. Open Terminal
2. Navigate to your project directory:
   ```bash
   cd "/Users/janetbalneaves/Documents/Cursor Projects/RootMate"
   ```
3. Run the archive command with automatic signing enabled:
   ```bash
   xcodebuild -project RootMate.xcodeproj \
     -scheme RootMate \
     -configuration Release \
     -destination 'generic/platform=iOS' \
     -archivePath ./build/RootMate.xcarchive \
     -allowProvisioningUpdates \
     CODE_SIGN_STYLE=Automatic \
     DEVELOPMENT_TEAM=QJANRR5HKM \
     archive
   ```
4. This creates the archive at `./build/RootMate.xcarchive`
5. Open Xcode → Window → Organizer
6. The archive should appear there
7. Click "Distribute App" to upload to App Store Connect

**Note:** Replace `QJANRR5HKM` with your actual team ID if different. You can find it in Xcode → Settings → Accounts → Select your team → Team ID.

**Why this happens:**
- Xcode validates signing for both Debug and Release configurations
- Development profiles (for Debug) require registered devices
- App Store Distribution profiles (for Release/Archive) don't require devices
- The error appears because Xcode can't create Development profiles, but this doesn't prevent App Store builds

### 7.3 Validate Archive

1. In the Organizer window (Archives tab), select your archive
2. Click **"Validate App"**
3. Follow the prompts:
   - Select your team
   - Choose "Automatically manage signing"
   - Click "Validate"
4. Wait for validation to complete
5. **Fix any errors** that appear
6. Common issues:
   - Missing app icon
   - Invalid entitlements
   - Missing required capabilities

### 7.4 Distribute App

1. Still in Organizer, with your archive selected
2. Click **"Distribute App"**
3. Select **"App Store Connect"** → **"Next"**
4. Select **"Upload"** → **"Next"**
5. Choose **"Automatically manage signing"** → **"Next"**
6. Review the summary → **"Upload"**
7. Wait for upload to complete (can take 10-30 minutes)

**Note:** You can also use the command line with `xcodebuild` or `xcrun altool`, but the GUI method above is easier for first-time submissions.

---

## Step 8: Submit for Review

Once your build is uploaded and processed:

### 8.1 Wait for Processing

1. Go back to App Store Connect
2. Go to your app → **"TestFlight"** or **"App Store"** tab
3. Wait for your build to appear (can take 10-60 minutes)
4. Status will show "Processing" → "Ready to Submit"

### 8.2 Select Build

1. Go to **"1.0 Prepare for Submission"** (or your version)
2. Scroll to **"Build"** section
3. Click **"+ Build"** or **"Select a build before you submit your app"**
4. Select your uploaded build
5. Click **"Done"**

### 8.3 Complete Submission Checklist

Before submitting, verify:

- [ ] Build is selected
- [ ] All required screenshots are uploaded
- [ ] Description is complete
- [ ] Keywords are entered
- [ ] Support URL is provided
- [ ] Privacy Policy URL is provided (if required)
- [ ] App icon is uploaded
- [ ] Version information is complete
- [ ] Export compliance information is answered (if prompted)
- [ ] Content rights are answered (if prompted)

### 8.4 Export Compliance

If prompted about Export Compliance:

1. **Does your app use encryption?**
   - Most apps use HTTPS (standard encryption) → Select "Yes"
   - If yes, you'll need to answer:
     - "Does your app use encryption other than HTTPS?" → Usually "No"
     - If "No", you can use the exemption: "App uses standard encryption"
   - If your app doesn't use any encryption → "No"

### 8.5 Submit for Review

1. Scroll to the top of "Prepare for Submission"
2. Click **"Add for Review"** or **"Submit for Review"**
3. Answer any final questions:
   - Contact information
   - Review notes (optional, but helpful)
   - Demo account (if your app requires login)
4. Click **"Submit"**

---

## Step 9: Review Process

### What Happens Next:

1. **Waiting for Review:** Your app is in the queue
2. **In Review:** Apple is actively reviewing your app
3. **Pending Developer Release:** Approved, waiting for you to release
4. **Ready for Sale:** Your app is live in the App Store!

### Timeline:

- **Initial review:** 24-48 hours (can be longer)
- **If rejected:** You'll get feedback, fix issues, resubmit
- **If approved:** You can release immediately or schedule release

### Common Rejection Reasons:

- Missing or incorrect privacy information
- App crashes or bugs
- Misleading descriptions
- Missing required information
- Violations of App Store guidelines

### If Your App is Rejected:

1. Read the rejection reason carefully
2. Fix the issues
3. Update your app (increment build number)
4. Create a new archive and upload
5. Resubmit with notes explaining what you fixed

---

## Step 10: After Approval

### 10.1 Release Your App

1. If status is "Pending Developer Release":
   - Go to App Store Connect
   - Click "Release This Version"
   - Your app will go live immediately

2. Or schedule a release:
   - Set a release date
   - App will automatically go live on that date

### 10.2 Monitor Your App

1. **App Store Connect Dashboard:**
   - View downloads, ratings, reviews
   - Monitor crash reports
   - Check analytics

2. **Respond to Reviews:**
   - Go to "Ratings and Reviews"
   - Respond to user feedback (helps with engagement)

---

## Quick Reference Checklist

Use this checklist to track your progress:

### Before Starting:
- [ ] Apple Developer account enrolled ($99/year)
- [ ] Xcode installed and updated
- [ ] App is fully tested

### Assets Prepared:
- [ ] 1024x1024 app icon
- [ ] 3-5 screenshots (1290 x 2796 pixels)
- [ ] App description written
- [ ] Keywords prepared
- [ ] Privacy policy URL ready
- [ ] Support URL ready

### Xcode Configuration:
- [ ] Signing & Capabilities configured
- [ ] Team selected
- [ ] Bundle ID matches App Store Connect
- [ ] Version and build numbers set
- [ ] App icon in Assets.xcassets

### App Store Connect:
- [ ] App created in App Store Connect
- [ ] Bundle ID registered
- [ ] App information filled in
- [ ] Pricing set
- [ ] Privacy information completed
- [ ] Screenshots uploaded
- [ ] Description and keywords entered
- [ ] Support and privacy URLs added

### Build & Submit:
- [ ] Archive created successfully
- [ ] Archive validated
- [ ] Build uploaded to App Store Connect
- [ ] Build processed and ready
- [ ] Build selected in submission
- [ ] All submission requirements met
- [ ] Submitted for review

---

## Troubleshooting Common Issues

### "Your team has no devices" Error

**This error appears when setting up signing for the first time.**

**✅ IMPORTANT: You don't need a physical device for App Store builds!** This warning will NOT prevent you from creating App Store builds or uploading to App Store Connect.

**Quick Fix (Recommended):**

1. **In Xcode, change the build destination:**
   - Look at the top toolbar in Xcode
   - Click on the device selector (currently might say "RootMate > iPhone 15 Pro" or similar)
   - Select **"Any iOS Device"** from the dropdown
   - This tells Xcode you're building for App Store distribution, not a specific device

2. **Continue with automatic signing:**
   - Make sure "Automatically manage signing" is still checked
   - The warning may still appear, but you can ignore it
   - Xcode will create App Store Distribution profiles automatically (these don't require devices)

3. **Proceed to archive:**
   - Product → Archive
   - This will work even with the "no devices" warning
   - The archive is for App Store distribution, not device testing

**Why this works:**
- App Store Distribution provisioning profiles don't require registered devices
- Development profiles require devices, but you're not using those for App Store builds
- The warning is just Xcode being cautious about development profiles

**Option 2: Add a Device (Optional - Only if you want to test on a device)**

If you want to register a device for testing (not required for App Store submission):

1. **If you have an iPhone/iPad:**
   - Connect your device to your Mac via USB
   - Unlock your device and trust the computer (tap "Trust" when prompted)
   - In Xcode: Window → Devices and Simulators (Shift+Cmd+2)
   - Your device should appear - Xcode will register it automatically
   - The warning should disappear after this

2. **Or manually add device:**
   - Go to: https://developer.apple.com/account/resources/devices/list
   - Click the **"+"** button
   - Select "Register a New Device"
   - Choose device type (iPhone, iPad, etc.)
   - Enter device name (e.g., "Janet's iPhone")
   - Enter UDID (see below for how to find it)
   - Click "Continue" → "Register"

   **To find UDID:**
   - **On Mac (if device connected):** Open Finder, select your device in sidebar, click on "Serial Number" text to reveal UDID
   - **On iPhone:** Settings → General → About → scroll to find UDID
   - **On Windows:** Use iTunes (if available) or 3uTools

**Option 3: Dismiss the Warning (Easiest)**

- Simply click "OK" or "Cancel" on the warning dialog
- Select "Any iOS Device" as your build destination
- Continue with your App Store build process
- The warning won't affect App Store distribution

**Bottom line:** 
- ✅ You can safely ignore this error for App Store builds
- ✅ Select "Any iOS Device" as your build destination
- ✅ Continue with archiving and uploading to App Store Connect
- ✅ The warning is about development profiles, not App Store distribution profiles

### "Communication with Apple failed: Your team has no devices" (During Archive)

**This error appears when trying to Archive and Xcode is attempting to create Development provisioning profiles.**

**Why this happens:**
- Xcode validates signing for both Debug and Release configurations before archiving
- Development profiles (for Debug builds) require registered devices
- App Store Distribution profiles (for Release/Archive) don't require devices
- Xcode fails when it can't create Development profiles, even though you don't need them for App Store builds

**Solution 1: Disable Automatic Signing for Debug (Recommended)**

This tells Xcode to only manage signing for Release builds (which are used for App Store):

1. In Xcode, select your project (blue icon) → "RootMate" target
2. Go to **"Signing & Capabilities"** tab
3. At the top, you'll see a dropdown for **"Debug"** and **"Release"** configurations
4. Select **"Debug"** from the dropdown
5. **Uncheck** "Automatically manage signing" for Debug
6. Select **"Release"** from the dropdown
7. **Make sure** "Automatically manage signing" is **checked** for Release
8. Select your Team for Release
9. Try archiving again: Product → Archive

**Solution 2: Add a Device (Quick Fix)**

If you have an iPhone/iPad:
1. Connect device via USB to your Mac
2. Unlock device and tap "Trust" when prompted
3. In Xcode: Window → Devices and Simulators (Shift+Cmd+2)
4. Your device should appear - Xcode registers it automatically
5. Try archiving again

**Solution 3: Use Command Line Archive (Bypass GUI Issues)**

If Xcode GUI keeps failing, archive via Terminal:

**Important:** Your project has `CODE_SIGN_STYLE = Manual` in the project file. Use the `-allowProvisioningUpdates` flag to enable automatic signing during the build.

1. Open Terminal
2. Navigate to your project directory:
   ```bash
   cd "/Users/janetbalneaves/Documents/Cursor Projects/RootMate"
   ```
3. Run the archive command with automatic signing:
   ```bash
   xcodebuild -project RootMate.xcodeproj \
     -scheme RootMate \
     -configuration Release \
     -destination 'generic/platform=iOS' \
     -archivePath ./build/RootMate.xcarchive \
     -allowProvisioningUpdates \
     CODE_SIGN_STYLE=Automatic \
     DEVELOPMENT_TEAM=QJANRR5HKM \
     archive
   ```
4. This creates the archive at `./build/RootMate.xcarchive`
5. Open Xcode → Window → Organizer
6. The archive should appear there
7. You can then click "Distribute App" to upload to App Store Connect

**Note:** Replace `QJANRR5HKM` with your actual team ID if different. Find it in Xcode → Settings → Accounts → Select your team → Team ID.

**Solution 4: Configure Build Settings (Advanced)**

If the above don't work, you can modify build settings:

1. Select project → "RootMate" target → **"Build Settings"** tab
2. Search for "Code Signing Style"
3. For **Debug** configuration, set to "Manual" (or leave empty)
4. For **Release** configuration, set to "Automatic"
5. Search for "Development Team"
6. Make sure your team (QJANRR5HKM) is set for **Release** configuration
7. Try archiving again

**Important Notes:**
- ✅ App Store Distribution profiles don't require devices
- ✅ You only need devices for Development profiles (used for testing on devices)
- ✅ For App Store submission, you only need Release configuration signing
- ✅ The error is about Development profiles, not Distribution profiles

### "No accounts with App Store Connect access"
- Make sure you're signed in with your Apple Developer account
- Verify your enrollment is active
- Try signing out and back in to Xcode

### "Bundle ID not found"
- Create the Bundle ID in developer.apple.com first
- Wait a few minutes for it to sync
- Refresh App Store Connect

### "No profiles for 'com.rootmate.RootMate' were found" (Archive Failed)

**This error means Xcode can't find provisioning profiles for your bundle ID when trying to archive.**

**⚠️ CRITICAL: The bundle ID must exist in your Apple Developer account BEFORE Xcode can create profiles.**

**Step-by-Step Fix:**

#### Step 1: Create the Bundle ID (MOST IMPORTANT - Do this first!)

1. **Go to Apple Developer Portal:**
   - Visit: https://developer.apple.com/account/resources/identifiers/list
   - Sign in with your Apple Developer account

2. **Check if Bundle ID exists:**
   - Look for `com.rootmate.RootMate` in the list
   - If it's NOT there, continue to create it

3. **Create the Bundle ID:**
   - Click the **"+"** button (top left)
   - Select **"App IDs"** → Click **"Continue"**
   - Select **"App"** → Click **"Continue"**
   - Fill in:
     - **Description:** `RootMate App` (or any description)
     - **Bundle ID:** Select **"Explicit"**
     - **Bundle ID field:** Enter `com.rootmate.RootMate` (exactly as shown)
   - **Enable Capabilities** (scroll down and check what you need):
     - ✅ Push Notifications (if your app uses notifications)
     - ✅ Associated Domains (if you use deep links)
     - ✅ Background Modes (if your app runs in background)
   - Click **"Continue"**
   - Review the summary → Click **"Register"**
   - Wait for confirmation

4. **Wait for sync:**
   - Wait 2-5 minutes for Apple's servers to sync
   - The bundle ID needs to be available to Xcode

#### Step 2: Configure Xcode Signing

1. **Open Xcode and your project**

2. **Select the project:**
   - Click the blue project icon at the top of the navigator
   - Select the **"RootMate"** target (under TARGETS)

3. **Go to Signing & Capabilities tab**

4. **Enable Automatic Signing:**
   - ✅ Check **"Automatically manage signing"**
   - Select your **Team** from the dropdown
   - If you don't see your team:
     - Click **"Add Account..."**
     - Sign in with your Apple Developer Apple ID
     - Wait for Xcode to fetch your account
     - Select your team from the dropdown

5. **Verify Bundle Identifier:**
   - Should show: `com.rootmate.RootMate`
   - If it's different, change it to match exactly

6. **Check for errors:**
   - You might see a yellow warning about "no devices" - that's OK, ignore it
   - If you see a red error about the bundle ID, the bundle ID might not be synced yet (wait a few more minutes)

#### Step 3: Set Build Destination for Archive

1. **In Xcode's top toolbar:**
   - Click the device selector (shows current device/simulator)
   - Select **"Any iOS Device"** from the dropdown
   - This is critical for App Store builds

#### Step 4: Refresh Xcode's Connection to Apple Developer

1. **Refresh accounts:**
   - Xcode → Settings (or Preferences) → **Accounts** tab
   - Select your Apple ID
   - Click **"Download Manual Profiles"** (if the button is available)
   - Or click **"Manage Certificates..."** to verify certificates exist

2. **If automatic signing still shows errors:**
   - In Signing & Capabilities, **uncheck** "Automatically manage signing"
   - Wait 5 seconds
   - **Check** it again
   - Select your Team again
   - This forces Xcode to refresh and create new profiles

#### Step 5: Clean and Try Archive Again

1. **Clean build folder:**
   - Product → Clean Build Folder (Shift+Cmd+K)
   - Or: Product → Clean (Cmd+Shift+K)

2. **Close and reopen Xcode** (optional but sometimes helps)

3. **Try archiving again:**
   - Make sure **"Any iOS Device"** is selected
   - Product → Archive
   - Xcode should now be able to create the App Store Distribution profile automatically

#### Step 6: If Still Not Working

**Verify your Apple Developer account:**
- Make sure you're enrolled in the Apple Developer Program ($99/year)
- Check enrollment status: https://developer.apple.com/account/
- Status should show "Active"

**Sign out and back in:**
- Xcode → Settings → Accounts
- Select your Apple ID → Click **"-"** to remove
- Click **"+"** → Add Apple ID → Sign in again
- Go back to Signing & Capabilities and select your team

**Check for certificate issues:**
- Xcode → Settings → Accounts
- Select your Apple ID → Click **"Manage Certificates..."**
- You should see certificates listed
- If empty, Xcode will create them automatically when you archive

**Manual verification:**
- Go to: https://developer.apple.com/account/resources/profiles/list
- Check if any profiles exist for `com.rootmate.RootMate`
- If profiles exist but Xcode can't see them, try the refresh steps above

**Note:** For App Store builds, Xcode needs to create an **App Store Distribution** provisioning profile. This happens automatically when:
- ✅ Bundle ID exists in Apple Developer
- ✅ Automatic signing is enabled
- ✅ Team is selected
- ✅ "Any iOS Device" is selected as build destination

### "Invalid provisioning profile"
- Make sure "Automatically manage signing" is checked
- Clean build folder and try again
- Delete derived data: `~/Library/Developer/Xcode/DerivedData`

### "Missing compliance"
- Answer export compliance questions
- Most apps can use "App uses standard encryption" exemption

### Build upload fails
- Check your internet connection
- Try again (sometimes it's a temporary issue)
- Make sure you're using the latest Xcode version

---

## Additional Resources

- **App Store Review Guidelines:** https://developer.apple.com/app-store/review/guidelines/
- **App Store Connect Help:** https://help.apple.com/app-store-connect/
- **Human Interface Guidelines:** https://developer.apple.com/design/human-interface-guidelines/
- **Apple Developer Forums:** https://developer.apple.com/forums/

---

## Next Steps After Launch

1. **Monitor Analytics:** Track downloads, user engagement
2. **Respond to Reviews:** Engage with users
3. **Plan Updates:** Regular updates keep your app fresh
4. **Marketing:** Promote your app through your website, social media
5. **Iterate:** Use feedback to improve your app

---

**Good luck with your App Store submission! 🚀**

If you encounter any issues not covered here, check Apple's documentation or developer forums for help.

