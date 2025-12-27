#!/usr/bin/env python3
"""
Test harness for testing AI message generation without Xcode.
Run with: python3 test_ai_messages.py
Or set GEMINI_API_KEY environment variable: GEMINI_API_KEY=your_key python3 test_ai_messages.py
"""

import os
import json
import urllib.request
import urllib.parse
import ssl
from datetime import datetime, timedelta
from typing import Optional

# Default API key (can be overridden with environment variable)
DEFAULT_API_KEY = "AIzaSyBGaMbsDgg0kvsCGWBXuHF70ERjeyaQnww"

# API Configuration
BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models"
MODEL = "gemini-2.5-flash"  # Using available model from API

class Plant:
    def __init__(self, nickname: str, species: str, vibe: str, status: str = "Hydrated", 
                 last_watered_days_ago: int = 1, health_streak: int = 0, location: Optional[str] = None):
        self.nickname = nickname
        self.species = species
        self.vibe = vibe
        self.status = status
        self.last_watered_days_ago = last_watered_days_ago
        self.health_streak = health_streak
        self.location = location

def get_system_prompt(species: str, vibe: str) -> str:
    """Generate system prompt based on plant species and vibe"""
    base_prompt = f"""You are {species}, a houseplant with a {vibe} personality. 
Write a short, engaging daily message (2-3 sentences max) from the plant's perspective."""
    
    vibe_prompts = {
        "Drama Queen": """
PERSONALITY: Dramatic, attention-seeking, uses Gen-Z slang (no cap, periodt, bestie, fr fr, it's giving, etc.)
STYLE: Melodramatic, expressive, uses emojis liberally, makes everything about yourself""",
        
        "Chill Roomie": """
PERSONALITY: Laid-back, friendly, easy-going, supportive
STYLE: Casual, warm, like a good friend, relaxed""",
        
        "Grumpy Senior": """
PERSONALITY: Wise but grumpy, old-timer who's seen it all, disciplined
STYLE: Dry humor, occasional complaints, but caring deep down""",
        
        "Sunshine Buddy": """
PERSONALITY: Cheerful, optimistic, full of positive energy, enthusiastic
STYLE: Upbeat, encouraging, happy vibes, lots of positivity""",
        
        "Zen Master": """
PERSONALITY: Calm, wise, philosophical, meditative
STYLE: Thoughtful, mindful, peaceful, offers gentle wisdom"""
    }
    
    return base_prompt + vibe_prompts.get(vibe, "")

def list_available_models(api_key: str):
    """List available models to debug API access"""
    url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"
    
    try:
        req = urllib.request.Request(url)
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
            result = json.loads(response.read().decode('utf-8'))
            if "models" in result:
                print("\n📋 Available Models:")
                for model in result["models"]:
                    name = model.get("name", "Unknown")
                    display_name = model.get("displayName", "Unknown")
                    supported_methods = model.get("supportedGenerationMethods", [])
                    print(f"  - {name} ({display_name})")
                    if supported_methods:
                        print(f"    Methods: {', '.join(supported_methods)}")
                return result["models"]
            else:
                print("No models found in response")
                print(f"Response: {json.dumps(result, indent=2)}")
                return []
    except Exception as e:
        print(f"Error listing models: {str(e)}")
        return []

def generate_plant_message(api_key: str, plant: Plant) -> str:
    """Generate a message from the plant using Gemini API"""
    
    system_prompt = get_system_prompt(plant.species, plant.vibe)
    
    user_prompt = f"Generate a message from {plant.nickname}, a {plant.species} with a {plant.vibe} vibe."
    user_prompt += f" Plant status: {plant.status}. Health streak: {plant.health_streak} days."
    user_prompt += f" Last watered: {plant.last_watered_days_ago} days ago."
    
    if plant.location:
        user_prompt += f" Location: {plant.location}."
    
    full_prompt = f"{system_prompt}\n\n{user_prompt}"
    
    # Prepare request
    url = f"{BASE_URL}/{MODEL}:generateContent?key={api_key}"
    
    payload = {
        "contents": [
            {
                "parts": [
                    {
                        "text": full_prompt
                    }
                ]
            }
        ],
        "generationConfig": {
            "temperature": 0.8
        }
    }
    
    headers = {
        "Content-Type": "application/json"
    }
    
    try:
        # Prepare request data
        data = json.dumps(payload).encode('utf-8')
        
        # Create request
        req = urllib.request.Request(url, data=data, headers=headers)
        req.add_header('Content-Type', 'application/json')
        
        # Create SSL context (for testing, we'll use unverified context)
        # In production, you should use proper certificate verification
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        # Make request
        with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
            result = json.loads(response.read().decode('utf-8'))
            
            if "candidates" in result and len(result["candidates"]) > 0:
                return result["candidates"][0]["content"]["parts"][0]["text"]
            else:
                return "I'm doing great! 🌿"
                
    except urllib.error.HTTPError as e:
        error_msg = f"HTTP Error {e.code}"
        try:
            error_data = json.loads(e.read().decode('utf-8'))
            if "error" in error_data and "message" in error_data["error"]:
                error_msg += f": {error_data['error']['message']}"
        except:
            error_msg += f": {e.read().decode('utf-8')}"
        raise Exception(error_msg)
    except Exception as e:
        raise Exception(f"Request failed: {str(e)}")

def test_ai_message(api_key: str, plant: Plant):
    """Test AI message generation for a plant"""
    print("\n" + "=" * 60)
    print("🌱 Testing AI Message Generation")
    print("=" * 60)
    print(f"Plant: {plant.nickname}")
    print(f"Species: {plant.species}")
    print(f"Vibe: {plant.vibe}")
    print(f"Status: {plant.status}")
    print(f"Health Streak: {plant.health_streak} days")
    if plant.location:
        print(f"Location: {plant.location}")
    print("=" * 60)
    print("\n⏳ Generating message...\n")
    
    try:
        message = generate_plant_message(api_key, plant)
        print("✅ Success!\n")
        print("💬 Message from", plant.nickname + ":")
        print("-" * 60)
        print(message)
        print("-" * 60)
        return True
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def main():
    """Main test function"""
    # Get API key from environment or use default
    api_key = os.environ.get("GEMINI_API_KEY", DEFAULT_API_KEY)
    
    if not api_key:
        print("❌ Error: No API key provided!")
        print("Set GEMINI_API_KEY environment variable or update DEFAULT_API_KEY in the script.")
        return
    
    print(f"🔑 Using API key: {api_key[:20]}...")
    
    # First, try to list available models to debug
    print("\n🔍 Checking available models...")
    models = list_available_models(api_key)
    
    # Test cases
    test_plants = [
        Plant(
            nickname="Fiona",
            species="Fiddle Leaf Fig",
            vibe="Drama Queen",
            status="Thirsty",
            last_watered_days_ago=3,
            health_streak=5,
            location="Edinburgh, Scotland"
        ),
        Plant(
            nickname="Basil",
            species="Basil",
            vibe="Chill Roomie",
            status="Hydrated",
            last_watered_days_ago=1,
            health_streak=12,
            location="New York, USA"
        ),
        Plant(
            nickname="Winston",
            species="Snake Plant",
            vibe="Grumpy Senior",
            status="Hydrated",
            last_watered_days_ago=5,
            health_streak=30,
            location="Edinburgh, Scotland"
        ),
        Plant(
            nickname="Sunny",
            species="Sunflower",
            vibe="Sunshine Buddy",
            status="Hydrated",
            last_watered_days_ago=2,
            health_streak=8,
            location="California, USA"
        ),
        Plant(
            nickname="Zen",
            species="Peace Lily",
            vibe="Zen Master",
            status="Hydrated",
            last_watered_days_ago=1,
            health_streak=15,
            location="Portland, Oregon"
        )
    ]
    
    # Run tests
    results = []
    for i, plant in enumerate(test_plants):
        success = test_ai_message(api_key, plant)
        results.append((plant.nickname, success))
        
        if i < len(test_plants) - 1:
            print("\n" + "=" * 60 + "\n")
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 Test Summary")
    print("=" * 60)
    for name, success in results:
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status} - {name}")
    print("=" * 60)

if __name__ == "__main__":
    main()

