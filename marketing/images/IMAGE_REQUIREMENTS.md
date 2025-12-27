# Marketing Images Requirements

This folder should contain the following image files for the RootMate marketing website:

## Required Images

### 1. `rootmate-logo.png`
**Description:** RootMate logo featuring a friendly cartoon plant in a terracotta pot with "Rootmate" text below
- **Format:** PNG (with transparency preferred)
- **Usage:** Navigation bar and footer across all pages
- **Recommended size:** 
  - Navigation: ~200px width (will be scaled to 50px height)
  - Footer: ~240px width (will be scaled to 60px height)
- **Details:** 
  - Cartoon-style green plant with friendly face (two eyes, open mouth with pink tongue, pink blush marks)
  - Two small leaves on top
  - Two stubby arms with three-fingered hands
  - Terracotta pot with darker brown rim
  - Dark green "Rootmate" text below
  - Light off-white background with subtle texture

### 2. `woman-using-app.jpg`
**Description:** Woman using RootMate app on smartphone with plants in the background
- **Format:** JPG
- **Usage:** Hero section on homepage and comparison page
- **Recommended size:** 1200px width minimum (will be responsive)
- **Details:**
  - Woman with dark skin, brown headwrap, wearing brown knit sweater and blue jeans
  - Smiling, looking at smartphone
  - RootMate notification visible on phone screen
  - Multiple potted plants on coffee table and window sill
  - Some plants have RootMate QR code stickers on terracotta pots
  - Bright, natural lighting from window
  - Modern, cozy living room setting

### 3. `pot-with-qr-stickers.jpg`
**Description:** Close-up of terracotta plant pot with multiple RootMate QR code stickers
- **Format:** JPG
- **Usage:** QR code feature section on homepage and comparison page
- **Recommended size:** 800px width minimum (will be responsive)
- **Details:**
  - Terracotta pot on light wooden windowsill
  - Five different RootMate QR code stickers on the pot:
    - Circular sticker (top left): White with green border, "Rootmate" text
    - Rectangular sticker (top right): White with "Scan Me" text
    - Leaf-shaped sticker (center): Green background, "My Voice" text
    - Hexagonal sticker (bottom left): Beige with green border, "Rootmate" and "Talk to the Plant" text
    - Speech bubble sticker (bottom right): Beige, "Watering Chat" text
  - Green plant visible (Pilea peperomioides or similar)
  - Natural light from window in background

### 4. `app-store-badge.svg` (Optional)
**Description:** Apple App Store download badge
- **Format:** SVG (or PNG)
- **Usage:** Download section on homepage
- **Recommended size:** Standard App Store badge dimensions
- **Note:** This is optional - the page will gracefully handle if missing

## Image Optimization Tips

1. **Compress images** before uploading to improve page load times
2. **Use appropriate formats:**
   - PNG for logos (supports transparency)
   - JPG for photos (smaller file size)
   - SVG for simple graphics (scalable)
3. **Consider responsive images:** You may want to provide multiple sizes for different screen resolutions
4. **Alt text:** All images have alt text in the HTML for accessibility

## File Structure

```
marketing/images/
├── rootmate-logo.png
├── woman-using-app.jpg
├── pot-with-qr-stickers.jpg
└── app-store-badge.svg (optional)
```

## Notes

- All image paths in the HTML are relative to the `marketing/` folder
- Images will automatically scale and be responsive
- The logo will be inverted to white in the footer for visibility on dark background
- Missing images will show broken image icons - make sure all required images are present

