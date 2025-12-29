#!/bin/bash

# Script to resize screenshots to iPhone 6.7" Display size (1284 x 2778)
# This is required for App Store submission
# App Store Connect accepts: 1242×2688, 1284×2778 (portrait) or their landscape equivalents

TARGET_WIDTH=1284
TARGET_HEIGHT=2778
SCREENSHOTS_DIR="$(dirname "$0")"

echo "Resizing screenshots to iPhone 6.7\" Display size (${TARGET_WIDTH} x ${TARGET_HEIGHT})..."
echo ""

# Find all PNG files in the screenshots directory
for file in "$SCREENSHOTS_DIR"/*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        
        # Skip if already resized (has -6.7in suffix)
        if [[ "$filename" == *"-6.7in.png" ]]; then
            echo "Skipping already resized: $filename"
            continue
        fi
        
        # Get current dimensions
        current_size=$(sips -g pixelWidth -g pixelHeight "$file" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        
        if [ -z "$current_size" ]; then
            echo "⚠️  Could not read dimensions for: $filename"
            continue
        fi
        
        echo "Resizing: $filename"
        echo "  Current size: $current_size"
        
        # Create output filename
        output_file="${file%.png}-6.7in.png"
        
        # Resize using sips (built into macOS)
        sips -z "$TARGET_HEIGHT" "$TARGET_WIDTH" "$file" --out "$output_file" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            # Verify new size
            new_size=$(sips -g pixelWidth -g pixelHeight "$output_file" 2>/dev/null | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
            echo "  ✅ Resized to: $new_size"
            echo "  Saved as: $(basename "$output_file")"
        else
            echo "  ❌ Failed to resize: $filename"
        fi
        echo ""
    fi
done

echo "Done! Check for files ending in '-6.7in.png'"
echo ""
echo "Note: Original files are preserved. Use the '-6.7in.png' versions for App Store submission."

