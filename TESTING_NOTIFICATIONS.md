# Testing UV Briefing Notifications Guide

## Why You're Not Receiving Evening Briefing

The evening briefing notification will **ONLY** be sent if **tomorrow's peak UV exceeds your threshold**.

### Common Reasons for No Notification:

1. **Tomorrow's UV is below threshold**
   - Check: Your UV threshold setting (default: 6)
   - Check: Tomorrow's actual UV forecast in your location
   - Solution: Lower your threshold temporarily for testing, or wait for a high UV day

2. **Notifications not enabled**
   - Check: Evening Briefing toggle is ON
   - Check: System notification permissions are granted

3. **Wrong time zone or forecast data**
   - The app needs forecast data to schedule notifications
   - Pull to refresh on the main screen to get latest data

## How to Test Notifications

### Method 1: Use Test Buttons (Fastest)
1. Go to **Settings** → **UV Notifications**
2. Scroll to the **Test Section** at bottom
3. Tap **"Test Evening Briefing (5 sec)"**
4. Wait 5 seconds, notification will appear
5. This tests the notification system without requiring actual UV data

### Method 2: Lower Threshold (Real Data)
1. Go to **Settings** → **UV Notifications**
2. Set **UV Sensitivity** to **3** (Low)
3. Make sure **Evening Briefing** is enabled
4. Go back to main screen and **pull to refresh** to reload forecast
5. Check Xcode console for: `"✅ Evening briefing scheduled for HH:MM"`
6. If you see `"⏭️ Evening briefing skipped: Tomorrow's peak UV..."` - tomorrow's UV is too low

### Method 3: Check Debug Console
When you refresh the main UV screen, look for these messages in Xcode console:

**Success:**
```
✅ Evening briefing scheduled for 20:00
```

**Skipped (UV too low):**
```
⏭️ Evening briefing skipped: Tomorrow's peak UV (4.2) below threshold (6)
```

**This tells you exactly why the notification wasn't scheduled!**

### Method 4: View Pending Notifications
1. Go to **Settings** → **UV Notifications**
2. Tap **"Debug: View Pending Notifications"**
3. Check Xcode console output
4. You'll see all scheduled notifications:
   ```
   📬 Pending Notifications: 2
     - morning-uv-briefing: ☀️ Today's UV Briefing
       Scheduled for: 2025-10-20 08:00:00
     - evening-uv-briefing: 🌙 Tomorrow's UV Briefing
       Scheduled for: 2025-10-19 20:00:00
   ```

## Understanding the Smart Logic

### Morning Briefing
- **When checked**: At your chosen time (e.g., 8:00 AM)
- **Condition**: TODAY's peak UV ≥ threshold
- **If UV below threshold**: No notification sent (zero spam!)

### Evening Briefing
- **When checked**: At your chosen time (e.g., 8:00 PM)
- **Condition**: TOMORROW's peak UV ≥ threshold
- **If UV below threshold**: No notification sent (zero spam!)

## Example Scenarios

### Scenario 1: Working Correctly
```
Your threshold: 6
Today's peak UV: 8 (High)
Tomorrow's peak UV: 7 (High)

Result:
✅ Morning briefing scheduled (today 8 ≥ 6)
✅ Evening briefing scheduled (tomorrow 7 ≥ 6)
```

### Scenario 2: Low UV Days
```
Your threshold: 6
Today's peak UV: 4 (Moderate)
Tomorrow's peak UV: 5 (Moderate)

Result:
⏭️ No morning briefing (today 4 < 6)
⏭️ No evening briefing (tomorrow 5 < 6)
```

### Scenario 3: Only Tomorrow is High
```
Your threshold: 6
Today's peak UV: 3 (Low)
Tomorrow's peak UV: 9 (Very High)

Result:
⏭️ No morning briefing (today 3 < 6)
✅ Evening briefing scheduled (tomorrow 9 ≥ 6)
```

## Troubleshooting Steps

### 1. Check System Permissions
- Settings app → UVGuard → Notifications
- Ensure "Allow Notifications" is ON
- In app: Green checkmark should show in notification status section

### 2. Verify Settings
- **UV Sensitivity**: Set to 3-6 for testing
- **Evening Briefing**: Toggle is ON
- **Evening Time**: Set to a time you can test (e.g., 2 minutes from now)

### 3. Force Refresh Data
- Go to main UV Index screen
- Pull down to refresh
- Wait for forecast data to load
- Check Xcode console for scheduling messages

### 4. Use Test Buttons
- **Fastest way**: Tap "Test Evening Briefing (5 sec)"
- This bypasses UV threshold logic
- Confirms notification system works

### 5. Check Xcode Console Output
Look for these key messages:
```
✅ Evening briefing scheduled for 20:00
⏭️ Evening briefing skipped: Tomorrow's peak UV (X.X) below threshold (Y)
📬 Pending Notifications: N
```

## Testing in Simulator vs Device

### Simulator
- ✅ Notifications appear as banners in macOS
- ✅ Can test timing and content
- ⚠️ May need to enable notifications in macOS System Settings

### Physical Device
- ✅ Real notification experience
- ✅ Sounds and badges work
- ✅ Lock screen notifications
- ⚠️ Must background app to see notification

## Quick Test Checklist

- [ ] System notifications enabled for UVGuard
- [ ] Evening Briefing toggle is ON
- [ ] UV Sensitivity set to 3 (for testing)
- [ ] Pulled to refresh on main screen
- [ ] Checked Xcode console for scheduling confirmation
- [ ] Tried "Test Evening Briefing" button
- [ ] Backgrounded app to receive notification
- [ ] Waited appropriate time for scheduled notification

## Understanding Console Messages

### ✅ Success Messages
```
✅ Evening briefing scheduled for 20:00
```
**Meaning**: Notification is scheduled and will fire at 8:00 PM daily

### ⏭️ Skip Messages
```
⏭️ Evening briefing skipped: Tomorrow's peak UV (4.5) below threshold (6)
```
**Meaning**: Tomorrow's UV is too low, no notification needed (this is correct behavior!)

### 📬 Pending List
```
📬 Pending Notifications: 1
  - evening-uv-briefing: 🌙 Tomorrow's UV Briefing
    Scheduled for: 2025-10-19 20:00:00
```
**Meaning**: You have 1 notification scheduled for tonight at 8 PM

## Pro Tips

1. **Start with threshold = 3** for testing (catches almost any UV level)
2. **Use test buttons** for immediate feedback
3. **Watch Xcode console** during pull-to-refresh
4. **Background the app** to receive notifications
5. **Check Settings → Notifications** if nothing works

## Common Mistakes

❌ Threshold set too high (9-11) on a moderate UV day  
✅ Set threshold to 3-6 for testing

❌ Not refreshing forecast data after changing settings  
✅ Pull to refresh on main screen

❌ Expecting notification immediately after enabling  
✅ Notifications fire at scheduled time (or use test button)

❌ App in foreground expecting banner notification  
✅ Background the app to see notification

---

**Remember**: The "zero spam" design means you WON'T get notifications on low UV days. This is a feature, not a bug! Use the test buttons to verify the notification system works.
