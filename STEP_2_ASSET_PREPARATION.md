# Step 2: Prepare Your App Assets

This guide will help you prepare all the assets needed for App Store submission.

## ✅ Current Status Check

Let's see what you already have:

- ✅ **Privacy Policy URL:** `https://rootmate.app/pages/privacy.html` (ready!)
- ✅ **Support/Contact URL:** `https://rootmate.app/pages/contact.html` (ready!)
- ✅ **Marketing URL:** `https://rootmate.app` (ready!)
- ⚠️ **App Icon:** Need to add 1024x1024 icon to AppIcon asset
- ⚠️ **Screenshots:** Need to take 3-5 screenshots
- ⚠️ **App Description:** Need to write (template provided below)
- ⚠️ **Keywords:** Need to prepare (suggestions below)

---

## 1. App Icon (1024x1024) - REQUIRED

**Status:** ⚠️ You need to add this

### What You Need:
- A 1024x1024 pixel image
- Format: PNG or JPEG (no transparency)
- Square (1:1 aspect ratio)
- High quality, clear design

### How to Add It:

**Good news!** You already have a logo at `marketing/images/rootmate-logo.png`. You can use this as a starting point.

1. **Convert your logo to 1024x1024:**
   
   **Option A: Using Preview (Mac - Easiest)**
   - Open `marketing/images/rootmate-logo.png` in Preview
   - Tools → Adjust Size
   - Set width: 1024, height: 1024
   - Make sure "Scale proportionally" is checked (or uncheck if you want square)
   - If your logo is rectangular, you may need to add padding/background
   - Save as PNG

   **Option B: Using Online Tools (Free)**
   - Go to https://www.iloveimg.com/resize-image or https://www.resizepixel.com
   - Upload `rootmate-logo.png`
   - Resize to 1024x1024
   - Download

   **Option C: Using Canva (Best for adding background)**
   - Create new design: Custom size 1024x1024
   - Upload your logo
   - Center it and add a background color if needed
   - Download as PNG

   **Option D: Using Design Tools**
   - Figma (free) - Create 1024x1024 frame, import logo, export
   - Photoshop - New document 1024x1024, import logo, export

2. **Add to Xcode:**
   - Open Xcode
   - Navigate to `Assets.xcassets` → `AppIcon`
   - Drag your 1024x1024 image into the "1024x1024" slot
   - Or right-click the slot → "Import" → select your image

3. **Verify:**
   - The icon should appear in the AppIcon set
   - Make sure it looks good at that size
   - Test how it looks (should be clear and recognizable)

### Icon Design Tips:
- Keep it simple and recognizable
- Avoid small text (won't be readable at small sizes)
- Use your brand colors
- Test how it looks on a dark background (iOS uses it in various contexts)

---

## 2. Screenshots - REQUIRED

**Status:** ⚠️ You need to take these

### What You Need:
- **Minimum:** 1 screenshot
- **Recommended:** 3-5 screenshots
- **Size:** 1290 x 2796 pixels (iPhone 6.7" display - iPhone 14 Pro Max, 15 Pro Max)
- **Format:** PNG or JPEG

### How to Take Screenshots:

#### Option A: Using iPhone Simulator (Easiest)

1. **Open your app in Xcode:**
   - Select "iPhone 15 Pro Max" or "iPhone 14 Pro Max" simulator
   - Run the app (⌘ + R)

2. **Navigate to key screens:**
   - **Screenshot 1:** My Rootmates dashboard (home screen)
   - **Screenshot 2:** Plant detail view (showing a plant's info)
   - **Screenshot 3:** Daily Chat view (showing a plant message)
   - **Screenshot 4:** Settings view (optional)
   - **Screenshot 5:** QR Code view (optional, even if "Coming Soon")

3. **Take screenshots:**
   - In Simulator: `⌘ + S` (saves to Desktop)
   - Or: Device → Screenshot

4. **Verify size:**
   - Screenshots from iPhone 15 Pro Max simulator are already 1290 x 2796 ✅

#### Option B: Using Real iPhone

1. **On your iPhone:**
   - Open the app
   - Navigate to each screen
   - Take screenshots (Side button + Volume up)

2. **Transfer to Mac:**
   - AirDrop, email, or connect via cable
   - Screenshots from iPhone 14 Pro Max or 15 Pro Max are the right size

3. **If using different iPhone:**
   - You may need to resize screenshots
   - Use Preview (Mac) or online tools

### Screenshot Best Practices:

**Screenshot 1 - Home/Dashboard:**
- Show the "My Rootmates" screen
- Make sure it shows multiple plants if possible
- Highlight the beautiful UI

**Screenshot 2 - Plant Detail:**
- Show a plant's profile
- Display status, health streak, personality
- Show the "Water Plant" button

**Screenshot 3 - Daily Chat:**
- Show a plant's personality message
- Highlight the AI-powered chat feature
- Show the engaging, fun personality

**Screenshot 4 - Features:**
- Could show settings, notifications, or another feature
- Or show multiple plants with different personalities

**Screenshot 5 - QR Codes (if ready):**
- Show the QR code feature
- Or skip if it's "Coming Soon"

### Screenshot Tips:
- Make sure the app looks polished
- Remove any test data or placeholder text
- Show real, engaging content
- Use plants with interesting personalities
- Make sure text is readable
- Avoid showing personal/sensitive information

---

## 3. App Description - REQUIRED

**Status:** ⚠️ You need to write this

### Template (Copy and customize):

```
RootMate gives your houseplants a personality. Each plant has its own voice—from Drama Queens using Gen-Z slang to Grumpy Seniors with dry wit. Get daily personalized, weather-aware, and hilarious messages from your plant rootmates. It's the Tamagotchi for real plants.

KEY FEATURES:

💬 Daily Plant Chat
Get personalized messages from your plants every day. Each message reflects your plant's unique personality, current status, and even the weather.

🌦️ Weather-Aware Updates
Your plants know when it's raining! They'll comment on the weather and adjust their messages accordingly.

📊 Health Tracking
Track your plant's health streak and status. See at a glance which plants are hydrated, thirsty, or need urgent care.

🔔 Smart Notifications
Get daily reminders from your plants at a time that works for you. Each notification is personalized to your plant's personality.

🌱 Plant Profiles
Each plant has its own profile with nickname, species, personality type, and care history. Get to know your rootmates!

💧 Watering Tracker
Log when you water your plants. Your plants remember and will reference your care in their daily messages.

🏷️ QR Code Stickers (Coming Soon)
Print branded QR code stickers for your plant pots. Perfect for plant sitters and house guests.

PERSONALITY TYPES:
• Drama Queen 💅 - Gen-Z slang, melodramatic, attention-seeking
• Chill Roomie 😎 - Laid back, supportive, easy-going
• Grumpy Senior 🤨 - Dry wit, disciplined, old-school
• Sunshine Buddy ☀️ - Energetic, positive, enthusiastic
• Zen Master 🧘 - Calm, wise, meditative

Why Personality Matters:
Most plant apps treat your green friends like data points. RootMate treats them like roommates with personalities. When your Fiddle Leaf Fig is a Drama Queen who uses Gen-Z slang, or your Snake Plant is a Grumpy Senior with dry wit, you don't just care for them—you care about them.

Perfect for both beginners and experienced plant parents who want plant care to be fun, engaging, and memorable.

Your plants called. They're thirsty. And they have opinions about it.
```

### Character Count:
- Max: 4000 characters
- This template: ~1,800 characters (plenty of room to expand)

### Tips:
- First 2-3 lines are most important (shown in search results)
- Use emojis sparingly (they count as characters)
- Highlight unique features
- Be authentic and fun (matches your app's personality!)
- Use bullet points for readability

---

## 4. Keywords - REQUIRED

**Status:** ⚠️ You need to prepare these

### Suggested Keywords:

```
plants,plant care,gardening,houseplants,reminders,plant tracker,plant app,plant care app,houseplant care,plant watering,plant reminders,plant personality,AI plants,smart plants
```

### Character Count:
- Max: 100 characters
- Above suggestion: ~130 characters (too long, need to trim)

### Optimized Version (under 100 characters):

```
plants,plant care,gardening,houseplants,reminders,plant tracker,plant watering,plant personality
```

**Count:** ~95 characters ✅

### Keyword Tips:
- No spaces after commas
- Use relevant terms people search for
- Think about what users would type
- Don't repeat words
- Include variations (plant/plants, care/caring)
- Test different combinations

### How to Choose:
1. Think: "What would I search for to find this app?"
2. Look at competitor apps' keywords (if visible)
3. Use App Store Connect's keyword suggestions
4. Include your unique features: "plant personality", "AI plants"

---

## 5. App Name & Subtitle

### App Name:
- **"RootMate"** (max 30 characters)
- ✅ You have 8 characters - plenty of room

### Subtitle (Optional):
- Max 30 characters
- Example: "Plants with Personality"
- Or: "Your Plant Care Companion"
- Or leave blank

---

## 6. Version Information

### Version:
- **"1.0"** (your first version)

### "What's New in This Version":
For first version, describe your app:

```
Welcome to RootMate! Your plants now have personalities and opinions. Track your plants, get daily personalized messages, and never forget to water again. It's plant care, but make it fun.
```

---

## 7. Copyright

Format: `© 2024 Your Name` or `© 2024 RootMate`

Example:
- `© 2024 RootMate`
- `© 2024 Janet Balneaves` (your name)

---

## 8. URLs - Already Ready! ✅

You already have these set up:

- **Privacy Policy:** `https://rootmate.app/pages/privacy.html`
- **Support URL:** `https://rootmate.app/pages/contact.html`
- **Marketing URL:** `https://rootmate.app` (optional)

**Action:** Just make sure these URLs are live and accessible when you submit!

---

## 📋 Step 2 Checklist

Use this to track your progress:

### App Icon:
- [ ] Created/found 1024x1024 icon image
- [ ] Added to `Assets.xcassets/AppIcon.appiconset/` in Xcode
- [ ] Verified it looks good

### Screenshots:
- [ ] Took screenshot 1: My Rootmates dashboard
- [ ] Took screenshot 2: Plant detail view
- [ ] Took screenshot 3: Daily Chat view
- [ ] Took screenshot 4: (optional) Another feature
- [ ] Took screenshot 5: (optional) QR Code view
- [ ] Verified all are 1290 x 2796 pixels
- [ ] Saved as PNG or JPEG files
- [ ] Reviewed - look polished and professional

### App Description:
- [ ] Wrote description (used template or custom)
- [ ] Under 4000 characters
- [ ] Highlights key features
- [ ] Engaging and fun (matches app personality)
- [ ] Saved in a text file for easy copy-paste

### Keywords:
- [ ] Prepared keyword list
- [ ] Under 100 characters
- [ ] No spaces after commas
- [ ] Relevant to your app
- [ ] Saved in a text file

### Other:
- [ ] Decided on app name (RootMate)
- [ ] Decided on subtitle (optional)
- [ ] Wrote "What's New" text for version 1.0
- [ ] Decided on copyright text
- [ ] Verified all URLs are live

---

## 🎯 Next Steps

Once you've completed Step 2:

1. **Save all assets in one place:**
   - Create a folder: `App Store Assets`
   - Put screenshots there
   - Save description and keywords as text files

2. **Wait for Step 1 approval:**
   - Your Apple Developer enrollment should be approved soon
   - Once approved, proceed to Step 3 (Xcode configuration)

3. **Review your assets:**
   - Show screenshots to friends/family for feedback
   - Make sure description is clear and compelling
   - Double-check all requirements are met

---

## 💡 Pro Tips

1. **Screenshots are your first impression:**
   - Make them count!
   - Show the most engaging, fun features
   - Highlight the personality aspect (your unique selling point)

2. **Description matters for search:**
   - First few lines appear in search results
   - Make them compelling
   - Include keywords naturally

3. **Test on different devices:**
   - Screenshots look different on various iPhones
   - iPhone 15 Pro Max screenshots work for all sizes (Apple scales them)

4. **Keep it authentic:**
   - Your app has personality - let that shine in the description
   - Don't be too corporate
   - Match the fun, engaging tone of your app

---

**Ready?** Once you have all these assets prepared, you'll be ready for Step 3 when your enrollment is approved! 🚀

