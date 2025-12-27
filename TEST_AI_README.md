# AI Message Testing Harness

Quick test script to test AI message generation without running Xcode.

## Usage

### Basic Usage
```bash
python3 test_ai_messages.py
```

### With Custom API Key
```bash
GEMINI_API_KEY=your_api_key_here python3 test_ai_messages.py
```

## What It Tests

The script tests AI message generation for 5 different plant personalities:

1. **Fiona** - Fiddle Leaf Fig (Drama Queen) - Thirsty, 3 days since watering
2. **Basil** - Basil (Chill Roomie) - Hydrated, 1 day since watering
3. **Winston** - Snake Plant (Grumpy Senior) - Hydrated, 5 days since watering
4. **Sunny** - Sunflower (Sunshine Buddy) - Hydrated, 2 days since watering
5. **Zen** - Peace Lily (Zen Master) - Hydrated, 1 day since watering

## Output

The script will:
- Show plant details for each test
- Generate a message using the Gemini API
- Display the generated message
- Provide a summary of all tests

## Customizing Tests

Edit `test_ai_messages.py` and modify the `test_plants` list in the `main()` function to test different scenarios:

```python
Plant(
    nickname="YourPlant",
    species="Plant Species",
    vibe="Drama Queen",  # or "Chill Roomie", "Grumpy Senior", "Sunshine Buddy", "Zen Master"
    status="Thirsty",    # or "Hydrated", "Critical"
    last_watered_days_ago=3,
    health_streak=5,
    location="Your City, Country"
)
```

## Requirements

- Python 3.6+ (uses built-in libraries only, no installation needed)

## Troubleshooting

If you get API errors, check:
- Your API key is valid
- You have internet connection
- The API key has proper permissions

