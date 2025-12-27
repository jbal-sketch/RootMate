# Notification Testing Guide

## Overview
RootMate sends daily local notifications for each plant at a user-specified time (default: 9:00 AM).

## Setting Notification Time

1. **Open Settings**: Tap the gear icon (⚙️) in the top-left of the home screen
2. **Navigate to Notifications Section**: Scroll to the "Notifications" section
3. **Set Time**: Use the DatePicker to select your preferred notification time
4. **Save**: Tap "Done" in the top-right
5. **Notifications Scheduled**: All plants will now receive notifications at this time daily

## Testing Notifications

### Method 1: Test Button in Settings (Recommended)
1. Open **Settings** (gear icon)
2. Scroll to **Notifications** section
3. Tap **"Test Notifications Now"** button
4. You should receive test notifications for all your plants (staggered by 2 seconds each)
5. Check your device's notification center to see the notifications

### Method 2: Simulator Testing
1. Run the app in Xcode Simulator
2. Set notification time in Settings
3. Use Simulator menu: **Device > Trigger Notification**
4. Or wait for the scheduled time (if testing with real time)

### Method 3: Device Testing with Time Change
1. Set notification time to a few minutes in the future
2. Save the time in Settings
3. Wait for the scheduled time
4. Notifications should appear automatically

## Notification Behavior

- **One notification per plant** at the scheduled time each day
- **Notification content** varies based on plant status:
  - **Thirsty**: "\[Plant Name\] is thirsty! Time for a drink 💧"
  - **Critical**: "🚨 \[Plant Name\] needs urgent care! Please water immediately."
  - **Hydrated**: "\[Plant Name\] says hello! Check in with your rootmate today 🌿"

## Permissions

The app will request notification permissions on first launch. You must grant permissions for notifications to work.

To check permissions:
- iOS Settings > RootMate > Notifications

## Troubleshooting

### Notifications Not Appearing
1. **Check Permissions**: Ensure notifications are enabled in iOS Settings
2. **Check Time**: Verify the notification time is set correctly in app Settings
3. **Check Do Not Disturb**: Make sure Do Not Disturb isn't blocking notifications
4. **Test Button**: Use the "Test Notifications Now" button to verify notifications work

### Notifications at Wrong Time
1. Open Settings
2. Check the notification time
3. Adjust if needed and tap "Done"
4. Notifications will reschedule automatically

### Multiple Notifications
- Each plant gets its own notification
- If you have 3 plants, you'll receive 3 notifications at the scheduled time
- This is expected behavior

## Code Location

- **Notification Service**: `Utilities/NotificationService.swift`
- **Settings UI**: `Views/SettingsView.swift`
- **Scheduling Logic**: Automatically scheduled when:
  - App launches
  - New plant is added
  - Notification time is changed

