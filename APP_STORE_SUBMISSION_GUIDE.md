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

2. **Sign in with your Apple ID:**
   - Use the same Apple ID you use for iCloud, App Store purchases, etc.
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
   - **iPhone 6.7" Display (iPhone 14 Pro Max, 15 Pro Max):**
     - Required: At least 1 screenshot
     - Recommended: 3-5 screenshots
     - Size: 1290 x 2796 pixels
   - **iPhone 6.5" Display (iPhone 11 Pro Max, XS Max):**
     - Size: 1242 x 2688 pixels
   - **iPhone 5.5" Display (iPhone 8 Plus):**
     - Size: 1242 x 2208 pixels
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
2. **For iPhone 6.7" Display:**
   - Click the screenshot area
   - Upload your screenshots (1290 x 2796 pixels)
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

1. Select **"Product"** → **"Archive"**
2. Xcode will:
   - Build your app
   - Create an archive
   - Open the Organizer window

**If you get errors:**
- Fix any code errors
- Make sure signing is configured correctly
- Check that all dependencies are resolved

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

### "No accounts with App Store Connect access"
- Make sure you're signed in with your Apple Developer account
- Verify your enrollment is active
- Try signing out and back in to Xcode

### "Bundle ID not found"
- Create the Bundle ID in developer.apple.com first
- Wait a few minutes for it to sync
- Refresh App Store Connect

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

