//
//  NotificationSettingsView.swift
//  UVGuard
//
//  Updated with system-controlled permissions and warm theme
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var settings = NotificationSettings.shared
    @State private var notificationManager = UVNotificationManager.shared
    @State private var showingTestNotification = false
    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        ZStack {
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Notification Status Section
                    notificationStatusSection
                    
                    // MARK: - UV Threshold Section
                    thresholdSection
                    
                    // MARK: - Morning Briefing Section
                    morningBriefingSection
                    
                    // MARK: - Evening Briefing Section
                    eveningBriefingSection
                    
                    // MARK: - Preview Section
                    previewSection
                    
                    // MARK: - Test Section
                    testSection
                }
                .padding()
            }
        }
        .navigationTitle("UV Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Test Notification Sent", isPresented: $showingTestNotification) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Check your notification center in a few seconds")
        }
        .onAppear {
            checkAuthorizationStatus()
        }
    }
    
    // MARK: - Notification Status Section
    private var notificationStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.uvAccent)
                    .font(.uvTitle2)
                
                Text("Notification Status")
                    .font(.uvTitle2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            HStack {
                statusIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authorizationStatusText)
                        .font(.uvHeadline)
                        .uvPrimaryText()
                    
                    Text(authorizationStatusDescription)
                        .font(.uvCaption)
                        .uvSecondaryText()
                }
                
                Spacer()
            }
            .padding()
            .background(Color.uvCardBackground.opacity(0.5))
            .cornerRadius(12)
            
            if authorizationStatus == .denied || authorizationStatus == .notDetermined {
                Button(action: openSettings) {
                    Text(authorizationStatus == .denied ? "Open Settings" : "Enable Notifications")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(UVPrimaryButtonStyle())
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - UV Threshold Section
    private var thresholdSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.uvAccent)
                
                Text("UV Sensitivity")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            HStack {
                Text("Alert Threshold")
                    .uvPrimaryText()
                Spacer()
                Text(settings.getThresholdDescription())
                    .font(.headline)
                    .uvSecondaryText()
            }
            
            // Discrete integer slider
            discreteThresholdSlider
            
            Text("Only receive notifications when UV index reaches or exceeds this level")
                .font(.caption)
                .uvSecondaryText()
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Morning Briefing Section
    private var morningBriefingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.uvAccent)
                
                Text("Morning Briefing")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            Toggle("Morning UV Briefing", isOn: $settings.morningBriefingEnabled)
                .uvPrimaryText()
            
            if settings.morningBriefingEnabled {
                DatePicker(
                    "Briefing Time",
                    selection: $settings.morningBriefingTime,
                    displayedComponents: .hourAndMinute
                )
                .uvPrimaryText()
            }
            
            Text("Get notified in the morning if today's UV will exceed your threshold")
                .font(.caption)
                .uvSecondaryText()
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Evening Briefing Section
    private var eveningBriefingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(.purple)
                
                Text("Evening Briefing")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            Toggle("Evening UV Briefing", isOn: $settings.eveningBriefingEnabled)
                .uvPrimaryText()
            
            if settings.eveningBriefingEnabled {
                DatePicker(
                    "Briefing Time",
                    selection: $settings.eveningBriefingTime,
                    displayedComponents: .hourAndMinute
                )
                .uvPrimaryText()
            }
            
            Text("Get notified in the evening if tomorrow's UV will exceed your threshold")
                .font(.caption)
                .uvSecondaryText()
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Daily Forecast Section (Deprecated)
    private var dailyForecastSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.uvAccent)
                
                Text("Daily Forecast")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            Toggle("Daily Forecast Summary", isOn: $settings.dailyForecastEnabled)
                .uvPrimaryText()
            
            if settings.dailyForecastEnabled {
                DatePicker(
                    "Notification Time",
                    selection: $settings.dailyForecastTime,
                    displayedComponents: .hourAndMinute
                )
                .uvPrimaryText()
            }
            
            Text("Receive a morning summary of today's UV forecast")
                .font(.caption)
                .uvSecondaryText()
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Discrete Threshold Slider
    private var discreteThresholdSlider: some View {
        VStack(spacing: 8) {
            // SwiftUI Slider with discrete steps
            Slider(
                value: Binding(
                    get: { Double(settings.uvThreshold) },
                    set: { settings.uvThreshold = Int($0.rounded()) }
                ),
                in: 3...11,
                step: 1
            )
            .tint(.uvAccent)
            
            // Value indicators below slider
            HStack {
                ForEach(3...11, id: \.self) { value in
                    VStack(spacing: 4) {
                        // Indicator dot
                        Circle()
                            .fill(settings.uvThreshold == value ? Color.uvAccent : Color.uvSecondaryText.opacity(0.3))
                            .frame(width: settings.uvThreshold == value ? 8 : 6, height: settings.uvThreshold == value ? 8 : 6)
                        
                        // Value label
                        Text("\(value)")
                            .font(.caption2)
                            .fontWeight(settings.uvThreshold == value ? .bold : .regular)
                            .foregroundColor(settings.uvThreshold == value ? .uvAccent : .uvSecondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example Notifications")
                .font(.title3)
                .fontWeight(.semibold)
                .uvPrimaryText()
            
            if settings.morningBriefingEnabled {
                NotificationPreviewCard(
                    icon: "sun.max.fill",
                    title: "Today's UV Briefing",
                    message: "Today: peak UV 9 (Very High) 12:00–14:30. Hat & SPF 50 recommended.",
                    color: .uvAccent
                )
            }
            
            if settings.eveningBriefingEnabled {
                NotificationPreviewCard(
                    icon: "moon.stars.fill",
                    title: " Tomorrow's UV Briefing",
                    message: "Tomorrow: peak UV 7 (High) 11:30–15:00. Hat & SPF 30+ recommended.",
                    color: .purple
                )
            }
            
            if !settings.morningBriefingEnabled && !settings.eveningBriefingEnabled {
                Text("Enable morning or evening briefings to see examples")
                    .font(.caption)
                    .uvSecondaryText()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Test Section
    private var testSection: some View {
        VStack(spacing: 12) {
            Button(action: sendTestMorningBriefing) {
                HStack {
                    Image(systemName: "sun.max.fill")
                    Text("Test Morning Briefing (5 sec)")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVSecondaryButtonStyle())
            
            Button(action: sendTestEveningBriefing) {
                HStack {
                    Image(systemName: "moon.stars.fill")
                    Text("Test Evening Briefing (5 sec)")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVSecondaryButtonStyle())
            
            Button(action: sendTestNotification) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                    Text("Send Generic Test (3 sec)")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVSecondaryButtonStyle())
            
            Button(action: {
                notificationManager.printPendingNotifications()
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Debug: View Pending Notifications")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVSecondaryButtonStyle())
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Helper Views
    private var statusIcon: some View {
        Group {
            switch authorizationStatus {
            case .authorized:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title)
            case .denied:
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.uvDanger)
                    .font(.title)
            case .notDetermined:
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.uvAccent)
                    .font(.title)
            default:
                Image(systemName: "bell.slash.fill")
                    .foregroundColor(.uvSecondaryText)
                    .font(.title)
            }
        }
    }
    
    private var authorizationStatusText: String {
        switch authorizationStatus {
        case .authorized: return "Enabled"
        case .denied: return "Disabled"
        case .notDetermined: return "Not Set"
        default: return "Unknown"
        }
    }
    
    private var authorizationStatusDescription: String {
        switch authorizationStatus {
        case .authorized: return "You'll receive UV notifications"
        case .denied: return "Notifications are blocked in Settings"
        case .notDetermined: return "Enable notifications to receive alerts"
        default: return "Check your notification settings"
        }
    }
    
    // MARK: - Helper Methods
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    private func openSettings() {
        if authorizationStatus == .notDetermined {
            Task {
                await notificationManager.requestAuthorization()
                checkAuthorizationStatus()
            }
        } else {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test UV Notification"
        content.body = "This is a test notification from UVGuard. Notifications are working! ☀️"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    showingTestNotification = true
                }
            }
        }
    }
    
    private func sendTestMorningBriefing() {
        let content = UNMutableNotificationContent()
        content.title = "☀️ Today's UV Briefing"
        content.body = "Today: peak UV 9 (Very High) 12:00–14:30. Hat & SPF 50 recommended."
        content.sound = .default
        content.badge = 1
        content.userInfo = ["type": "test-morning-briefing"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "test-morning-briefing", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    showingTestNotification = true
                }
            }
        }
        print("📱 Test morning briefing will arrive in 5 seconds")
    }
    
    private func sendTestEveningBriefing() {
        let content = UNMutableNotificationContent()
        content.title = "🌙 Tomorrow's UV Briefing"
        content.body = "Tomorrow: peak UV 7 (High) 11:30–15:00. Hat & SPF 30+ recommended."
        content.sound = .default
        content.badge = 1
        content.userInfo = ["type": "test-evening-briefing"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "test-evening-briefing", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    showingTestNotification = true
                }
            }
        }
        print("📱 Test evening briefing will arrive in 5 seconds")
    }
}

// MARK: - Notification Preview Card

struct NotificationPreviewCard: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .uvPrimaryText()

                Text(message)
                    .font(.caption)
                    .uvSecondaryText()
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
