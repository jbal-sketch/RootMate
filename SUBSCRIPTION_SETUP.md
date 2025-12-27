# Subscription Setup Guide

This guide explains how to configure the RootMate subscription in App Store Connect.

## Subscription Details

- **Product ID**: `com.rootmate.premium.monthly`
- **Price**: $1.99/month
- **Free Trial**: 7 days
- **Features**: Daily AI-powered updates for up to 5 plants

## App Store Connect Configuration

### Step 1: Create Subscription Group

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to your app
3. Go to **Features** → **In-App Purchases**
4. Click **+** to create a new subscription group
5. Name it "RootMate Premium" (or similar)

### Step 2: Create Subscription Product

1. Within the subscription group, click **+** to add a subscription
2. Fill in the details:
   - **Reference Name**: RootMate Premium Monthly
   - **Product ID**: `com.rootmate.premium.monthly` (must match exactly)
   - **Subscription Duration**: 1 Month
   - **Price**: $1.99 (or your chosen price tier)

### Step 3: Configure Free Trial

1. In the subscription product, scroll to **Subscription Prices**
2. Click **+** to add a price schedule
3. Set the **Introductory Price**:
   - **Type**: Free Trial
   - **Duration**: 7 days
   - **Start Date**: Set to your app launch date (or leave as default)

### Step 4: Localization

Add localized descriptions for your subscription:
- **Display Name**: RootMate Premium
- **Description**: Get daily AI-powered messages from your plants, weather-aware updates, and track up to 5 plants with a 7-day free trial.

### Step 5: Review Information

Add review information:
- **Review Notes**: Explain the subscription features and free trial
- **Screenshot**: Optional - add a screenshot showing the subscription screen

### Step 6: Submit for Review

1. Complete all required fields (marked with *)
2. Submit the subscription for review along with your app
3. Apple typically reviews subscriptions within 24-48 hours

## Testing

### Sandbox Testing

1. Create a sandbox tester account in App Store Connect:
   - **Users and Access** → **Sandbox Testers** → **+**
   - Create a test Apple ID (can be any email, doesn't need to be real)

2. Test in your app:
   - Sign out of your real Apple ID in Settings → App Store
   - Run the app in Xcode
   - When prompted, sign in with your sandbox tester account
   - Test the subscription purchase flow

### Important Notes

- **Product ID**: The product ID `com.rootmate.premium.monthly` is hardcoded in `SubscriptionService.swift`. If you change it in App Store Connect, update it in the code.
- **Testing**: Subscriptions only work in sandbox/test mode until your app is approved
- **Free Trial**: The 7-day free trial is configured in App Store Connect, not in code
- **Receipt Validation**: StoreKit 2 handles receipt validation automatically

## Code Configuration

The subscription service is already configured in:
- `Utilities/SubscriptionService.swift` - Main subscription logic
- `Views/SubscriptionView.swift` - Subscription UI/paywall
- `ViewModels/PlantViewModel.swift` - Feature gating (5 plant limit, daily updates)

## Feature Gating

The app enforces the following limits:
- **Non-subscribers**: Cannot add more than 5 plants, cannot generate daily messages
- **Subscribers (including trial)**: Can add up to 5 plants, get daily AI-powered messages

## Troubleshooting

### Subscription not showing
- Verify product ID matches exactly: `com.rootmate.premium.monthly`
- Check that subscription is approved in App Store Connect
- Ensure you're testing with a sandbox account

### Free trial not working
- Verify introductory offer is configured in App Store Connect
- Check that the offer is set to "Free Trial" with 7-day duration
- Ensure the offer start date is in the past

### Purchase fails
- Check sandbox account is signed in
- Verify subscription is in "Ready to Submit" or "Approved" status
- Check App Store Connect for any errors or warnings

## Support

For issues with StoreKit 2 or subscriptions, refer to:
- [Apple's StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

