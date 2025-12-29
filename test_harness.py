#!/usr/bin/env python3
"""
Test harness for RootMate backend API.
Tests the /api/generate-message endpoint that the iOS app uses.

Usage:
    python3 test_harness.py [--url URL] [--vibe VIBE] [--all]

Options:
    --url URL          Backend API URL (default: https://root-mate.vercel.app)
    --vibe VIBE        Test specific vibe (Drama Queen, Chill Roomie, etc.)
    --all              Run all test suites
    --quick            Run quick connectivity test only
"""

import os
import sys
import json
import urllib.request
import urllib.parse
import ssl
import argparse
from datetime import datetime, timedelta
from typing import Optional, Dict, List, Tuple

# Default configuration
DEFAULT_BACKEND_URL = "https://root-mate.vercel.app"
API_ENDPOINT = "/api/generate-message"

# Plant vibes
PLANT_VIBES = [
    "Drama Queen",
    "Chill Roomie", 
    "Grumpy Senior",
    "Sunshine Buddy",
    "Zen Master"
]

# Plant statuses
PLANT_STATUSES = ["Hydrated", "Thirsty", "Critical"]

class Colors:
    """ANSI color codes for terminal output"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

class TestResult:
    """Represents a test result"""
    def __init__(self, name: str, success: bool, message: str, duration: float = 0.0):
        self.name = name
        self.success = success
        self.message = message
        self.duration = duration
        self.timestamp = datetime.now()

def print_header(text: str):
    """Print a formatted header"""
    print(f"\n{Colors.BOLD}{Colors.CYAN}{'=' * 70}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.CYAN}{text.center(70)}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.CYAN}{'=' * 70}{Colors.RESET}\n")

def print_success(text: str):
    """Print success message"""
    print(f"{Colors.GREEN}✅ {text}{Colors.RESET}")

def print_error(text: str):
    """Print error message"""
    print(f"{Colors.RED}❌ {text}{Colors.RESET}")

def print_warning(text: str):
    """Print warning message"""
    print(f"{Colors.YELLOW}⚠️  {text}{Colors.RESET}")

def print_info(text: str):
    """Print info message"""
    print(f"{Colors.BLUE}ℹ️  {text}{Colors.RESET}")

def get_system_prompt(species: str, vibe: str) -> str:
    """Generate system prompt based on plant species and vibe"""
    base_prompt = f"You are {species}, a houseplant with a {vibe} personality. Write a short, engaging daily message (2-3 sentences max) from the plant's perspective."
    
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

def test_api_connectivity(base_url: str) -> TestResult:
    """Test basic API connectivity"""
    start_time = datetime.now()
    url = f"{base_url}{API_ENDPOINT}"
    
    try:
        # Create a minimal test request
        test_data = {
            "plant": {
                "nickname": "Test",
                "species": "Test Plant",
                "vibe": "Chill Roomie",
                "status": "Hydrated",
                "healthStreak": 1
            },
            "systemPrompt": "You are a test plant."
        }
        
        req = urllib.request.Request(url, method="POST")
        req.add_header("Content-Type", "application/json")
        data = json.dumps(test_data).encode('utf-8')
        req.data = data
        
        # Create SSL context that doesn't verify certificates (for testing)
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, timeout=10, context=ssl_context) as response:
            if response.status == 200:
                result_data = json.loads(response.read().decode('utf-8'))
                duration = (datetime.now() - start_time).total_seconds()
                
                if "message" in result_data and result_data["message"]:
                    return TestResult(
                        "API Connectivity",
                        True,
                        f"Successfully connected to {base_url} (Status: {response.status}, Duration: {duration:.2f}s)",
                        duration
                    )
                else:
                    return TestResult(
                        "API Connectivity",
                        False,
                        "Connected but received empty message",
                        duration
                    )
            else:
                duration = (datetime.now() - start_time).total_seconds()
                return TestResult(
                    "API Connectivity",
                    False,
                    f"HTTP {response.status}: {response.read().decode('utf-8')}",
                    duration
                )
    except urllib.error.HTTPError as e:
        duration = (datetime.now() - start_time).total_seconds()
        error_body = e.read().decode('utf-8') if e.fp else "No error details"
        return TestResult(
            "API Connectivity",
            False,
            f"HTTP {e.code}: {error_body}",
            duration
        )
    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        return TestResult(
            "API Connectivity",
            False,
            f"Connection failed: {str(e)}",
            duration
        )

def test_message_generation(
    base_url: str,
    nickname: str,
    species: str,
    vibe: str,
    status: str = "Hydrated",
    health_streak: int = 5,
    last_watered_days_ago: int = 3,
    weather_data: Optional[Dict] = None
) -> TestResult:
    """Test message generation for a specific plant configuration"""
    start_time = datetime.now()
    url = f"{base_url}{API_ENDPOINT}"
    
    # Calculate last watered date
    last_watered = (datetime.now() - timedelta(days=last_watered_days_ago)).isoformat() + "Z"
    
    system_prompt = get_system_prompt(species, vibe)
    
    request_data = {
        "plant": {
            "nickname": nickname,
            "species": species,
            "vibe": vibe,
            "status": status,
            "healthStreak": health_streak,
            "lastWatered": last_watered
        },
        "systemPrompt": system_prompt
    }
    
    if weather_data:
        request_data["weatherData"] = weather_data
    
    try:
        req = urllib.request.Request(url, method="POST")
        req.add_header("Content-Type", "application/json")
        data = json.dumps(request_data).encode('utf-8')
        req.data = data
        
        # Create SSL context that doesn't verify certificates (for testing)
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, timeout=30, context=ssl_context) as response:
            if response.status == 200:
                result_data = json.loads(response.read().decode('utf-8'))
                duration = (datetime.now() - start_time).total_seconds()
                
                if "message" in result_data:
                    message = result_data["message"]
                    return TestResult(
                        f"Message Generation ({nickname})",
                        True,
                        f"Generated message ({len(message)} chars, {duration:.2f}s):\n    {message[:100]}{'...' if len(message) > 100 else ''}",
                        duration
                    )
                else:
                    return TestResult(
                        f"Message Generation ({nickname})",
                        False,
                        "Response missing 'message' field",
                        duration
                    )
            else:
                duration = (datetime.now() - start_time).total_seconds()
                error_body = response.read().decode('utf-8')
                return TestResult(
                    f"Message Generation ({nickname})",
                    False,
                    f"HTTP {response.status}: {error_body}",
                    duration
                )
    except urllib.error.HTTPError as e:
        duration = (datetime.now() - start_time).total_seconds()
        error_body = e.read().decode('utf-8') if e.fp else "No error details"
        try:
            error_json = json.loads(error_body)
            error_msg = error_json.get("error", error_body)
        except:
            error_msg = error_body
        return TestResult(
            f"Message Generation ({nickname})",
            False,
            f"HTTP {e.code}: {error_msg}",
            duration
        )
    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        return TestResult(
            f"Message Generation ({nickname})",
            False,
            f"Request failed: {str(e)}",
            duration
        )

def test_all_vibes(base_url: str) -> List[TestResult]:
    """Test message generation for all plant vibes"""
    results = []
    
    test_plant = {
        "nickname": "Test",
        "species": "Fiddle Leaf Fig",
        "status": "Hydrated",
        "health_streak": 5,
        "last_watered_days_ago": 2
    }
    
    for vibe in PLANT_VIBES:
        result = test_message_generation(
            base_url=base_url,
            nickname=f"Test{vibe.replace(' ', '')}",
            species=test_plant["species"],
            vibe=vibe,
            status=test_plant["status"],
            health_streak=test_plant["health_streak"],
            last_watered_days_ago=test_plant["last_watered_days_ago"]
        )
        results.append(result)
    
    return results

def test_all_statuses(base_url: str) -> List[TestResult]:
    """Test message generation for all plant statuses"""
    results = []
    
    for status in PLANT_STATUSES:
        result = test_message_generation(
            base_url=base_url,
            nickname=f"Test{status}",
            species="Snake Plant",
            vibe="Chill Roomie",
            status=status,
            health_streak=5,
            last_watered_days_ago=3 if status == "Thirsty" else (7 if status == "Critical" else 1)
        )
        results.append(result)
    
    return results

def test_with_weather(base_url: str) -> TestResult:
    """Test message generation with weather data"""
    weather_data = {
        "current": {
            "temperature": 15.5,
            "humidity": 75.0,
            "precipitation": 2.5
        }
    }
    
    return test_message_generation(
        base_url=base_url,
        nickname="WeatherTest",
        species="Pothos",
        vibe="Drama Queen",
        status="Thirsty",
        health_streak=3,
        last_watered_days_ago=4,
        weather_data=weather_data
    )

def test_base_url(base_url: str) -> TestResult:
    """Test if the base URL is accessible"""
    start_time = datetime.now()
    try:
        req = urllib.request.Request(base_url, method="GET")
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, timeout=10, context=ssl_context) as response:
            duration = (datetime.now() - start_time).total_seconds()
            return TestResult(
                "Base URL Accessibility",
                True,
                f"Base URL is accessible (Status: {response.status}, Duration: {duration:.2f}s)",
                duration
            )
    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        return TestResult(
            "Base URL Accessibility",
            False,
            f"Base URL not accessible: {str(e)}",
            duration
        )

def test_api_endpoint_exists(base_url: str) -> TestResult:
    """Test if the API endpoint exists (even if it returns an error)"""
    start_time = datetime.now()
    url = f"{base_url}{API_ENDPOINT}"
    
    try:
        # Try OPTIONS request first (should work even if POST doesn't)
        req = urllib.request.Request(url, method="OPTIONS")
        req.add_header("Content-Type", "application/json")
        ssl_context = ssl.create_default_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, timeout=10, context=ssl_context) as response:
            duration = (datetime.now() - start_time).total_seconds()
            return TestResult(
                "API Endpoint Exists",
                True,
                f"API endpoint exists (Status: {response.status}, Duration: {duration:.2f}s)",
                duration
            )
    except urllib.error.HTTPError as e:
        duration = (datetime.now() - start_time).total_seconds()
        # 404 means endpoint doesn't exist, other errors mean it exists but has issues
        if e.code == 404:
            return TestResult(
                "API Endpoint Exists",
                False,
                f"API endpoint NOT FOUND (404) - Function not deployed",
                duration
            )
        else:
            return TestResult(
                "API Endpoint Exists",
                True,
                f"API endpoint exists but returned {e.code} (endpoint is deployed)",
                duration
            )
    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        return TestResult(
            "API Endpoint Exists",
            False,
            f"Error checking endpoint: {str(e)}",
            duration
        )

def run_diagnostics(base_url: str) -> List[TestResult]:
    """Run comprehensive diagnostics"""
    print_header("Diagnostic Tests")
    results = []
    
    # Test 1: Base URL accessibility
    print_info("Testing base URL accessibility...")
    results.append(test_base_url(base_url))
    
    # Test 2: API endpoint existence
    print_info("Testing if API endpoint exists...")
    results.append(test_api_endpoint_exists(base_url))
    
    # Test 3: Full API connectivity
    print_info("Testing full API connectivity...")
    results.append(test_api_connectivity(base_url))
    
    return results

def run_quick_test(base_url: str) -> List[TestResult]:
    """Run a quick connectivity test"""
    print_header("Quick Connectivity Test")
    results = [test_api_connectivity(base_url)]
    return results

def run_all_tests(base_url: str) -> List[TestResult]:
    """Run all test suites"""
    all_results = []
    
    # Connectivity test
    print_header("API Connectivity Test")
    all_results.append(test_api_connectivity(base_url))
    
    # Test all vibes
    print_header("Testing All Plant Vibes")
    vibe_results = test_all_vibes(base_url)
    all_results.extend(vibe_results)
    
    # Test all statuses
    print_header("Testing All Plant Statuses")
    status_results = test_all_statuses(base_url)
    all_results.extend(status_results)
    
    # Test with weather
    print_header("Testing With Weather Data")
    all_results.append(test_with_weather(base_url))
    
    return all_results

def print_results(results: List[TestResult]):
    """Print test results summary"""
    print_header("Test Results Summary")
    
    passed = sum(1 for r in results if r.success)
    failed = len(results) - passed
    total_duration = sum(r.duration for r in results)
    
    for result in results:
        if result.success:
            print_success(f"{result.name}")
            print(f"   {result.message}")
        else:
            print_error(f"{result.name}")
            print(f"   {result.message}")
        print()
    
    print(f"{Colors.BOLD}Summary:{Colors.RESET}")
    print(f"  Total: {len(results)}")
    print_success(f"Passed: {passed}")
    if failed > 0:
        print_error(f"Failed: {failed}")
    print_info(f"Total Duration: {total_duration:.2f}s")
    print(f"  Average: {total_duration/len(results):.2f}s per test")
    
    print(f"\n{Colors.BOLD}{Colors.CYAN}{'=' * 70}{Colors.RESET}\n")

def main():
    parser = argparse.ArgumentParser(description="Test harness for RootMate backend API")
    parser.add_argument("--url", default=DEFAULT_BACKEND_URL, help=f"Backend API URL (default: {DEFAULT_BACKEND_URL})")
    parser.add_argument("--vibe", choices=PLANT_VIBES, help="Test specific vibe")
    parser.add_argument("--all", action="store_true", help="Run all test suites")
    parser.add_argument("--quick", action="store_true", help="Run quick connectivity test only")
    parser.add_argument("--diagnose", action="store_true", help="Run diagnostic tests to identify issues")
    
    args = parser.parse_args()
    
    base_url = args.url.rstrip('/')
    
    print_header("RootMate API Test Harness")
    print_info(f"Testing endpoint: {base_url}{API_ENDPOINT}")
    print()
    
    if args.diagnose:
        results = run_diagnostics(base_url)
    elif args.quick:
        results = run_quick_test(base_url)
    elif args.vibe:
        print_header(f"Testing {args.vibe} Vibe")
        result = test_message_generation(
            base_url=base_url,
            nickname="TestPlant",
            species="Fiddle Leaf Fig",
            vibe=args.vibe,
            status="Thirsty",
            health_streak=5,
            last_watered_days_ago=3
        )
        results = [result]
    elif args.all:
        results = run_all_tests(base_url)
    else:
        # Default: run connectivity + all vibes
        print_header("Default Test Suite")
        results = [test_api_connectivity(base_url)]
        print_header("Testing All Plant Vibes")
        results.extend(test_all_vibes(base_url))
    
    print_results(results)
    
    # Exit with error code if any tests failed
    if any(not r.success for r in results):
        sys.exit(1)

if __name__ == "__main__":
    main()

