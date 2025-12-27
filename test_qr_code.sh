#!/bin/bash

# QR Code Testing Helper Script
# This script helps test QR code deep linking in the iOS Simulator

echo "🔍 RootMate QR Code Testing Helper"
echo "=================================="
echo ""

# Check if plant ID is provided
if [ -z "$1" ]; then
    echo "Usage: ./test_qr_code.sh <plant-id>"
    echo ""
    echo "Example:"
    echo "  ./test_qr_code.sh 123e4567-e89b-12d3-a456-426614174000"
    echo ""
    echo "To find a plant ID:"
    echo "  1. Run the app in Xcode"
    echo "  2. Tap on a plant to open detail view"
    echo "  3. Check Xcode console for plant ID (or add debug print)"
    echo ""
    echo "Or use a test UUID:"
    echo "  ./test_qr_code.sh 00000000-0000-0000-0000-000000000001"
    exit 1
fi

PLANT_ID=$1

# Validate UUID format
if [[ ! $PLANT_ID =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
    echo "❌ Error: Invalid UUID format"
    echo "Expected format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    exit 1
fi

echo "📱 Testing deep link for plant: $PLANT_ID"
echo ""

# Test direct URL scheme
echo "1️⃣ Testing direct URL scheme..."
xcrun simctl openurl booted "rootmate://plant/$PLANT_ID"

if [ $? -eq 0 ]; then
    echo "✅ URL opened successfully"
    echo "   The app should open and navigate to the plant detail view"
else
    echo "❌ Failed to open URL"
    echo "   Make sure:"
    echo "   - Simulator is running"
    echo "   - RootMate app is installed in simulator"
fi

echo ""
echo "2️⃣ Web URL (for testing web fallback):"
echo "   http://localhost:8000/plant/$PLANT_ID"
echo ""
echo "   To test web fallback:"
echo "   1. Start local server: cd marketing && python3 -m http.server 8000"
echo "   2. Open URL in browser (not on device with app installed)"
echo ""

echo "3️⃣ QR Code URL format:"
echo "   https://rootmate.app/plant/$PLANT_ID"
echo ""

echo "✨ Testing complete!"
echo ""
echo "💡 Tips:"
echo "   - If app doesn't open, check Info.plist has rootmate:// scheme registered"
echo "   - For web testing, update domain in QRCodeGenerator.swift"
echo "   - Use QR code generator online to create test QR codes"

