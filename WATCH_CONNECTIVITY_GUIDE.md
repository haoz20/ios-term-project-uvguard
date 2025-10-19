# WatchConnectivity Setup Guide

## Overview
WatchConnectivity has been implemented to enable real-time data sync between iPhone and Apple Watch.

## What Was Added

### iPhone App (`UVGuard`)

1. **WatchConnectivityManager.swift** - New service file
   - Activates WCSession on launch
   - Sends UV data via `sendMessage()` (instant) or `updateApplicationContext()` (background)
   - Sends cities via `updateApplicationContext()`
   - Sends hourly forecast data

2. **UVGuardApp.swift** - Updated
   - Initializes `WatchConnectivityManager.shared` on launch

3. **UVIndexViewModel.swift** - Updated
   - Calls `WatchConnectivityManager.shared.sendUVData()` when UV data updates
   - Calls `WatchConnectivityManager.shared.sendHourlyForecast()` for forecast data

4. **CitiesView.swift** - Updated
   - Calls `WatchConnectivityManager.shared.sendCities()` when cities are added/deleted

### Apple Watch App (`WatchUVGuard Watch App`)

1. **Services/WatchConnectivityManager.swift** - New service file
   - Activates WCSession on launch
   - Receives data from iPhone via messages and application context
   - Stores data in @Observable properties
   - Saves data to SharedDataManager
   - Posts notifications when data updates

2. **WatchUVGuardApp.swift** - Updated
   - Initializes `WatchConnectivityManager.shared` on launch

3. **UVIndexViewModel.swift** - Updated
   - Observes `WatchDataUpdated` notifications
   - Prioritizes WatchConnectivity data over SharedDataManager
   - `refresh()` now requests fresh data from iPhone

4. **CitiesViewModel.swift** - Updated
   - Observes `WatchDataUpdated` notifications
   - Prioritizes WatchConnectivity data over App Groups UserDefaults
   - `refresh()` now requests fresh data from iPhone

## How It Works

### iPhone → Watch Data Flow

1. **Immediate Updates** (when Watch is reachable):
   - iPhone calls `sendUVData()` → sends via `sendMessage()` → Watch receives instantly

2. **Background Updates** (when Watch is not reachable):
   - iPhone calls `sendUVData()` → sends via `updateApplicationContext()` → Watch receives when active
   - iPhone calls `sendCities()` → always uses `updateApplicationContext()` for reliability

3. **Data Synced**:
   - Current UV index
   - Location (city, country)
   - Cities list
   - Hourly forecast

### Watch → iPhone Communication

- Watch can request data refresh via `requestDataFromiPhone()`
- iPhone receives refresh request and triggers data fetch
- New data is sent back to Watch automatically

## Testing

### On Real Devices

1. **Build and Install**:
   - Build iPhone app on your iPhone
   - Build Watch app on your Apple Watch
   - Ensure both devices are paired

2. **Test UV Data Sync**:
   - Open iPhone app
   - Allow location access
   - Wait for UV data to load
   - Open Watch app → should show same UV data instantly

3. **Test Cities Sync**:
   - Add a city on iPhone app
   - Open Watch app → Cities list → should show the new city

4. **Test Refresh**:
   - On Watch, pull down to refresh
   - Should request fresh data from iPhone

### Expected Console Logs

**iPhone:**
```
📱 WCSession activated with state: 2
📱 Sent UV data to Watch via ApplicationContext
📱 Sent 3 cities to Watch via ApplicationContext
```

**Watch:**
```
⌚ WCSession activated with state: 2
⌚ Received application context: ["currentUV", "city", "country"]
⌚ Context UV: 8.15
⌚ Context location: Bangkok, Thailand
⌚ Context cities: 3
```

## Advantages Over App Groups Only

1. **Real-time sync** - Instant updates when Watch is active
2. **Automatic delivery** - `updateApplicationContext()` ensures Watch gets data
3. **Bi-directional** - Watch can request fresh data from iPhone
4. **Reliable** - Falls back to App Groups if WatchConnectivity fails
5. **Apple recommended** - Official API for Watch communication

## Troubleshooting

### Watch shows "No UV data"

1. Check iPhone app has loaded UV data
2. Check both devices are paired in Watch app
3. Try pulling down to refresh on Watch
4. Check Console logs for errors

### Data not syncing

1. Ensure both apps have WatchConnectivity initialized
2. Check `WCSession.activationState == .activated`
3. Verify App Groups entitlement is still present
4. Try rebuilding both targets

### Performance issues

- WatchConnectivity is fast and shouldn't cause lag
- If issues persist, check for other blocking operations
- Ensure all data operations are async with `Task { @MainActor in }`

## Files to Add to Xcode Project

Make sure these new files are added to their respective targets:

**iOS Target (UVGuard):**
- `Services/WatchConnectivityManager.swift`

**Watch Target (WatchUVGuard Watch App):**
- `Services/WatchConnectivityManager.swift`
- `Services/` folder

## Next Steps

1. Build and test on real devices (WatchConnectivity doesn't work well in simulators)
2. Monitor console logs to verify data flow
3. Test all scenarios (add city, delete city, refresh UV, etc.)
4. Watch app should now update in real-time! 🎉
