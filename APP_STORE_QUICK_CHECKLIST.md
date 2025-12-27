# App Store Submission - Quick Checklist

Use this as a quick reference while you work through the full guide.

## ⚠️ Before You Start - Critical Items

### 1. Apple Developer Account
- [ ] Enroll at https://developer.apple.com/programs/ ($99/year)
- [ ] Wait for approval (1-2 weeks)
- [ ] Verify you can log in to https://appstoreconnect.apple.com

### 2. App Icon (REQUIRED)
- [ ] Create a 1024x1024 pixel icon (PNG or JPEG, no transparency)
- [ ] Add it to `Assets.xcassets/AppIcon.appiconset/`
- [ ] This is **mandatory** - your app will be rejected without it

### 3. Screenshots (REQUIRED)
- [ ] Take 3-5 screenshots on iPhone (1290 x 2796 pixels for iPhone 14 Pro Max)
- [ ] Show your app's key features
- [ ] Save as PNG or JPEG files

### 4. Privacy Policy (REQUIRED if app collects data)
- [ ] Create a privacy policy page
- [ ] Host it on your website (e.g., `https://rootmate.app/pages/privacy.html`)
- [ ] Your app uses notifications, so you'll need to explain this

### 5. App Description
- [ ] Write a compelling description (max 4000 characters)
- [ ] Prepare keywords (max 100 characters, comma-separated)

---

## 📋 Submission Steps Summary

1. **Enroll** → Apple Developer Program ($99/year)
2. **Prepare** → Assets (icon, screenshots, description)
3. **Configure** → Xcode signing & capabilities
4. **Create** → App in App Store Connect
5. **Fill in** → App Store listing information
6. **Build** → Archive and validate in Xcode
7. **Upload** → Distribute to App Store Connect
8. **Submit** → For review
9. **Wait** → 24-48 hours for review
10. **Release** → Go live!

---

## 🔍 Special Considerations for RootMate

### Permissions Your App Uses:
- ✅ **Notifications** - You'll need to explain this in App Privacy
- ✅ **Deep Linking** - Already configured in Info.plist

### App Privacy Questions You'll Need to Answer:
1. **Does your app collect data?**
   - You'll need to declare if you collect:
     - User content (plant data, notes)
     - Usage data (analytics)
     - Diagnostics (crash reports)

2. **How is data used?**
   - App functionality (storing user's plants)
   - Analytics (if you use any)
   - Product personalization

3. **Is data linked to user identity?**
   - If users can create accounts: Yes
   - If purely local storage: No

4. **Is data used for tracking?**
   - Usually "No" unless you use advertising/tracking SDKs

### Recommended Privacy Policy Sections:
- What data you collect (plant information, preferences)
- How you use it (app functionality, notifications)
- Data storage (local vs. cloud)
- Third-party services (if any)
- User rights (how to delete data)

---

## 🚨 Common First-Time Mistakes to Avoid

1. **Missing App Icon** - Must be 1024x1024, in AppIcon asset
2. **Wrong Bundle ID** - Must match exactly between Xcode and App Store Connect
3. **Missing Privacy Policy** - Required if app collects any data
4. **Incorrect Screenshot Sizes** - Use correct dimensions for each device
5. **Not Testing on Real Device** - Always test before submitting
6. **Export Compliance** - Answer "Yes, uses standard encryption" (HTTPS)

---

## ⏱️ Estimated Timeline

- **Developer Enrollment:** 1-2 weeks (mostly waiting)
- **Asset Preparation:** 1-2 days
- **Xcode Setup:** 1-2 hours
- **App Store Connect Setup:** 2-4 hours
- **Build & Upload:** 1-2 hours
- **Review Process:** 24-48 hours
- **Total:** ~2-3 weeks from start to App Store

---

## 📞 Need Help?

- **Full Guide:** See `APP_STORE_SUBMISSION_GUIDE.md`
- **Apple Support:** https://developer.apple.com/support/
- **App Store Connect Help:** https://help.apple.com/app-store-connect/

---

## ✅ Final Pre-Submission Checklist

Before clicking "Submit for Review":

- [ ] App icon (1024x1024) uploaded
- [ ] Screenshots uploaded (at least 1, recommended 3-5)
- [ ] Description written and complete
- [ ] Keywords entered
- [ ] Support URL provided
- [ ] Privacy Policy URL provided (if required)
- [ ] App Privacy questions answered
- [ ] Build selected and ready
- [ ] Export compliance answered
- [ ] App tested on real device
- [ ] No crashes or major bugs
- [ ] All features working as expected

**Ready?** Follow the full guide step-by-step! 🚀

