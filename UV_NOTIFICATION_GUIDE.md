# UV Notification System - Implementation Guide

## Overview
The UVGuard app now includes a comprehensive notification system that alerts users about UV levels based on their preferences.

## Features Implemented

### 1. Daily Forecast Summary
- **What**: Morning notification with peak UV forecast
- **When**: User-configurable time (default: 7 AM)
- **Content**: 
  - Peak UV index for the day
  - UV level description (Low/Moderate/High/Very High/Extreme)
  - Protective recommendations

### 2. UV Threshold Alerts
- **What**: Notifications when UV index reaches or exceeds user-defined threshold
- **When**: 15 minutes before the high UV hour
- **Content**:
  - Specific UV index and time
  - Level-appropriate protective advice
  - Critical alerts for very high/extreme levels

### 3. Notification Settings
- Enable/disable notifications
- Set UV threshold (3.0 - 11.0)
- Configure daily forecast time
- Toggle individual notification types
- Test notifications
- Preview examples

## Required Setup Steps

### Step 1: Add Notification Capability to Info.plist

Add the following to your `Info.plist` file:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

### Step 2: Update App Delegate (if using UIKit lifecycle)

If you're using SwiftUI App lifecycle (which you are), you're good to go! The notification center is automatically configured.

### Step 3: Request Notification Permission

The app automatically requests permission when the user enables notifications in settings.

## How It Works

### Data Flow:
1. User enables notifications in Settings
2. App requests notification permission from iOS
3. UV data is fetched from API
4. `UVIndexViewModel` processes the data
5. If notifications enabled, schedules:
   - Daily forecast (recurring)
   - Threshold alerts (one-time per hour that exceeds threshold)

### Notification Scheduling:
- **Daily Forecast**: Uses `UNCalendarNotificationTrigger` with daily repeat
- **Threshold Alerts**: Uses `UNCalendarNotificationTrigger` for specific date/time
- All notifications are local (no server required)

## Testing Instructions

### Test Notifications:
1. Open Settings → UV Notifications
2. Enable notifications (grant permission)
3. Tap "Send Test Notification"
4. Wait 3 seconds for notification to appear

### Test Daily Forecast:
1. Set notification time to 1 minute from now
2. Enable "Daily Forecast Summary"
3. Wait for notification (or use "View Pending Notifications" to verify it's scheduled)

### Test Threshold Alerts:
1. Set threshold to a low value (e.g., 3.0)
2. Enable "UV Threshold Alerts"
3. Fetch UV data (pull to refresh on home screen)
4. Check pending notifications in console logs

### Debug Tips:
```swift
// View all scheduled notifications (add to button in settings)
notificationManager.printPendingNotifications()

// Output shows:
// - Notification ID
// - Title
// - Scheduled date/time
```

## Files Created/Modified

### New Files:
1. **`Services/UVNotificationManager.swift`**
   - Handles all notification scheduling and management
   - Permission requests
   - Notification content generation

2. **`Models/NotificationSettings.swift`**
   - User preference storage (UserDefaults)
   - Observable settings object
   - Threshold level calculations

3. **`Views/NotificationSettingsView.swift`**
   - Full UI for notification configuration
   - Preview cards
   - Test functionality

### Modified Files:
1. **`ViewModels/UVIndexViewModel.swift`**
   - Added timezone storage
   - Added notification scheduling after data fetch
   - Integrated with NotificationSettings

2. **`Views/SettingsView.swift`**
   - Added navigation link to NotificationSettingsView
   - Status indicator for enabled notifications

## Notification Examples

### Daily Forecast (Moderate UV):
```
Title: Today's UV Forecast ☀️
Body: Peak UV Index: 5.2 (Moderate)
      Stay in shade during midday hours.
```

### Daily Forecast (High UV):
```
Title: Today's UV Forecast ☀️
Body: Peak UV Index: 7.8 (High)
      ⚠️ Protection essential! Wear sunscreen and avoid midday sun.
```

### Threshold Alert (High):
```
Title: ⚠️ High UV Alert
Body: UV Index will reach 6.5 (High) at 2:00 PM.
      ☀️ Use SPF 30+ sunscreen and wear protective clothing.
```

### Threshold Alert (Extreme):
```
Title: ⚠️ High UV Alert
Body: UV Index will reach 11.2 (Extreme) at 1:00 PM.
      🚨 Stay indoors if possible. Full protection required outside.
```

## Best Practices

### For Users:
1. Set threshold based on skin type:
   - Fair skin: 3-4 (Moderate)
   - Medium skin: 6-7 (High)
   - Dark skin: 8+ (Very High)

2. Enable daily forecast to plan outdoor activities

3. Allow notifications for better sun safety

### For Developers:
1. Always check notification authorization status
2. Handle permission denials gracefully
3. Provide clear messaging about notification benefits
4. Test on physical device (simulator has limitations)
5. Clear old notifications to avoid clutter

## Troubleshooting

### Notifications Not Appearing:
1. Check iOS Settings → UVGuard → Notifications (must be enabled)
2. Verify notification permission was granted
3. Check pending notifications in debug console
4. Ensure device is not in Do Not Disturb mode
5. Test on physical device (simulator may be unreliable)

### Wrong Notification Times:
1. Verify timezone is correctly set from API
2. Check DateFormatter timezone configuration
3. Ensure device time/timezone is correct

### Duplicate Notifications:
1. Notifications are removed before rescheduling
2. Check that `removeThresholdNotifications()` is being called

## Future Enhancements

### Potential Features:
- [ ] Snooze functionality
- [ ] Notification actions (e.g., "View Details")
- [ ] Widget integration
- [ ] Notification history
- [ ] Custom notification sounds
- [ ] Location-based notifications (different thresholds for different cities)
- [ ] Weekly UV summary
- [ ] Sunset/sunrise UV warnings

### Advanced:
- [ ] Push notifications for breaking UV alerts
- [ ] Machine learning for personalized recommendations
- [ ] Integration with Apple Health (sun exposure tracking)
- [ ] Shortcuts support for quick threshold changes

## Code Architecture

```
UVGuardApp
├── Models
│   ├── NotificationSettings (UserDefaults + @Observable)
│   └── UVLevel (enum for UV categories)
├── Services
│   ├── UVNotificationManager (singleton, handles UNUserNotificationCenter)
│   └── LocationDataManager (existing)
├── ViewModels
│   └── UVIndexViewModel (fetches data, triggers notifications)
└── Views
    ├── NotificationSettingsView (full configuration UI)
    └── SettingsView (main settings with nav link)
```

## Summary

Your UV notification system is now complete with:
✅ Daily forecast summaries
✅ Threshold-based alerts
✅ Full settings UI
✅ Notification previews
✅ Test functionality
✅ Permission handling
✅ UserDefaults persistence

The system automatically schedules notifications when UV data is fetched, respects user preferences, and provides helpful protective advice based on UV levels.
