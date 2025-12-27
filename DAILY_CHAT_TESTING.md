# Testing Daily Chats

## How to Test Daily Chats

### Prerequisites

1. **Google Gemini API Key**: You need a Google Gemini API key to generate AI messages
   - Get one from: https://aistudio.google.com/app/apikey
   - The app uses Gemini 1.5 Flash model (fast and efficient)

### Step 1: Configure API Key

You need to configure the Google Gemini API key in your app. There are two ways:

#### Option A: Use Settings View (Recommended)

1. Open the app
2. Tap the gear icon (⚙️) in the top-left
3. Enter your Gemini API key in the "AI Configuration" section
4. Tap "Done" to save

#### Option B: Hardcode for Testing (Quick but not secure)

1. Open `RootMateApp.swift` or `MyRootmatesView.swift`
2. In the `onAppear` or `init`, add:
   ```swift
   viewModel.configureAI(apiKey: "your-gemini-api-key-here")
   ```

### Step 2: Test Daily Chat

1. **Run the app** in the simulator
2. **Tap on any plant** (e.g., Fiona, Basil, or Winston) to open Plant Detail View
3. **Scroll down** to see the "Daily Chat" section
4. **Tap "Chat with [Plant Name]"** button
5. **In the chat view**, tap **"Get Today's Message"** button
6. **Wait for the AI** to generate a personalized message (may take 5-10 seconds)
7. **Read the message** - it should match the plant's vibe!

### Expected Behavior

- **Drama Queen plants** (like Fiona) will use Gen-Z slang, be dramatic, and use lots of emojis
- **Chill Roomie plants** (like Basil) will be laid back and friendly
- **Grumpy Senior plants** (like Winston) will have dry wit and old-school language
- **Sunshine Buddy plants** will be energetic and positive
- **Zen Master plants** will be calm and meditative

### What Gets Included in Messages

The AI considers:
- Plant nickname and species
- Plant vibe/personality
- Current plant status (Hydrated/Thirsty/Critical)
- Health streak (days of good care)
- Days since last watering
- Weather data (if location is set)

### Troubleshooting

**Error: "AI service not configured"**
- Make sure you've called `viewModel.configureAI(apiKey: "...")` with a valid Google Gemini API key
- Check that the API key is saved in Settings

**Error: "Failed to fetch weather"**
- This is okay! The app will still generate messages without weather data
- Weather is optional and enhances the message but isn't required

**Message takes too long**
- Normal! AI generation can take 5-15 seconds depending on API response time
- Check your internet connection

**No message appears**
- Check the console for error messages
- Verify your API key is valid and has credits/quota
- Make sure you're using a valid Gemini model (check AIService.swift - currently using gemini-1.5-flash)

### Example Messages

**Drama Queen (Fiona - Thirsty):**
> "OMG bestie, it's literally POURING outside and I'm still THIRSTY?? 😤💀 Like, the sky is crying buckets and I'm over here looking like I just walked through a desert?? The AUDACITY..."

**Chill Roomie (Basil - Hydrated):**
> "Hey! Just wanted to check in and say I'm doing great! 🌿 The weather's been nice and I'm feeling pretty good. Thanks for taking care of me!"

**Grumpy Senior (Winston - Hydrated):**
> "Well, I suppose I should acknowledge that you've been keeping up with my care. Back in my day, plants didn't need all this attention, but I must admit, I'm in good shape."

### Tips

- Try different plant statuses (water them or let them get thirsty) to see how messages change
- Test with different vibes to see personality differences
- Messages are generated fresh each time - they won't be the same every day!

