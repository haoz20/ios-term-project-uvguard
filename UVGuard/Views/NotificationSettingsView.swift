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
                    
                    // MARK: - Daily Forecast Section
                    dailyForecastSection
                    
                    // MARK: - UV Threshold Section
                    thresholdSection
                    
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
                    .font(.title2)
                
                Text("Notification Status")
                    .font(.title2)
                    .fontWeight(.bold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            HStack {
                statusIcon
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authorizationStatusText)
                        .font(.headline)
                        .uvPrimaryText()
                    
                    Text(authorizationStatusDescription)
                        .font(.caption)
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
    
    // MARK: - Daily Forecast Section
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
    
    // MARK: - UV Threshold Section
    private var thresholdSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.uvDanger)
                
                Text("UV Threshold Alerts")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            Toggle("UV Threshold Alerts", isOn: $settings.thresholdNotificationsEnabled)
                .uvPrimaryText()
            
            if settings.thresholdNotificationsEnabled {
                VStack(spacing: 16) {
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
                }
            }
            
            Text("Get notified 15 minutes before UV index reaches or exceeds this level")
                .font(.caption)
                .uvSecondaryText()
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Discrete Threshold Slider
    private var discreteThresholdSlider: some View {
        let thresholdValues = [3, 4, 5, 6, 7, 8, 9, 10, 11]
        
        return GeometryReader { geometry in
            let spacing = (geometry.size.width - 40) / CGFloat(thresholdValues.count - 1)
            
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .fill(Color.uvSecondaryText.opacity(0.2))
                    .frame(height: 4)
                    .cornerRadius(2)
                    .padding(.horizontal, 20)
                
                // Dots
                HStack(spacing: 0) {
                    ForEach(Array(thresholdValues.enumerated()), id: \.offset) { index, value in
                        Circle()
                            .fill(settings.uvThreshold == value ? Color.uvAccent : Color.uvSecondaryText.opacity(0.4))
                            .frame(width: settings.uvThreshold == value ? 16 : 12, height: settings.uvThreshold == value ? 16 : 12)
                            .overlay(
                                Text("\(value)")
                                    .font(.caption2)
                                    .uvSecondaryText()
                                    .offset(y: 20)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    settings.uvThreshold = value
                                }
                            }
                        
                        if index < thresholdValues.count - 1 {
                            Spacer()
                                .frame(width: spacing)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(height: 50)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let position = value.location.x - 20
                    let totalWidth = UIScreen.main.bounds.width - 80
                    let spacing = totalWidth / CGFloat(thresholdValues.count - 1)
                    let index = Int(round(position / spacing))
                    let clampedIndex = max(0, min(thresholdValues.count - 1, index))
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        settings.uvThreshold = thresholdValues[clampedIndex]
                    }
                }
        )
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Example Notifications")
                .font(.title3)
                .fontWeight(.semibold)
                .uvPrimaryText()
            
            if settings.dailyForecastEnabled {
                NotificationPreviewCard(
                    icon: "sun.max.fill",
                    title: "Today's UV Forecast ☀️",
                    message: "Peak UV Index: 7.5 (High)\n⚠️ Protection essential! Wear sunscreen and avoid midday sun.",
                    color: .uvAccent
                )
            }
            
            if settings.thresholdNotificationsEnabled {
                NotificationPreviewCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "⚠️ High UV Alert",
                    message: "UV Index will reach \(settings.uvThreshold) at 2:00 PM.\n☀️ Use SPF 30+ sunscreen and wear protective clothing.",
                    color: .uvDanger
                )
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Test Section
    private var testSection: some View {
        VStack(spacing: 12) {
            Button(action: sendTestNotification) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                    Text("Send Test Notification")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(UVSecondaryButtonStyle())
            
            Button(action: {
                notificationManager.printPendingNotifications()
            }) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("View Pending Notifications")
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
