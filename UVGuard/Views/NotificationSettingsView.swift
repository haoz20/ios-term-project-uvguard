//
//  NotificationSettingsView.swift
//  UVGuard
//
//  Created on UV Notification Implementation
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var settings = NotificationSettings.shared
    @State private var notificationManager = UVNotificationManager.shared
    @State private var showingPermissionAlert = false
    @State private var showingTestNotification = false
    
    var body: some View {
        Form {
            // MARK: - Enable Notifications Section
            Section {
                Toggle("Enable Notifications", isOn: $settings.notificationsEnabled)
                    .onChange(of: settings.notificationsEnabled) { _, newValue in
                        if newValue {
                            requestNotificationPermission()
                        }
                    }
                
                if notificationManager.authorizationStatus == .denied {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Notifications are disabled in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("Notifications")
            } footer: {
                Text("Get alerts when UV index reaches certain levels")
            }
            
            if settings.notificationsEnabled {
                // MARK: - Daily Forecast Section
                Section {
                    Toggle("Daily Forecast Summary", isOn: $settings.dailyForecastEnabled)
                    
                    if settings.dailyForecastEnabled {
                        DatePicker(
                            "Notification Time",
                            selection: $settings.dailyForecastTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                } header: {
                    Text("Daily Forecast")
                } footer: {
                    Text("Receive a morning summary of today's UV forecast")
                }
                
                // MARK: - UV Threshold Section
                Section {
                    Toggle("UV Threshold Alerts", isOn: $settings.thresholdNotificationsEnabled)
                    
                    if settings.thresholdNotificationsEnabled {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Alert Threshold")
                                Spacer()
                                Text(settings.getThresholdDescription())
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(
                                value: $settings.uvThreshold,
                                in: 3.0...11.0,
                                step: 0.5
                            )
                            
                            // UV Level Indicator
                            HStack(spacing: 8) {
                                ForEach([3.0, 6.0, 8.0, 11.0], id: \.self) { value in
                                    VStack(spacing: 4) {
                                        Circle()
                                            .fill(getColorForUV(value))
                                            .frame(width: 12, height: 12)
                                        Text(String(format: "%.0f", value))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    if value != 11.0 {
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                } header: {
                    Text("UV Threshold Alerts")
                } footer: {
                    Text("Get notified 15 minutes before UV index reaches or exceeds this level")
                }
                
                // MARK: - Preview Section
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example Notifications")
                            .font(.headline)
                        
                        if settings.dailyForecastEnabled {
                            NotificationPreviewCard(
                                icon: "sun.max.fill",
                                title: "Today's UV Forecast ☀️",
                                _body: "Peak UV Index: 7.5 (High)\n⚠️ Protection essential! Wear sunscreen and avoid midday sun.",
                                color: .orange
                            )
                        }
                        
                        if settings.thresholdNotificationsEnabled {
                            NotificationPreviewCard(
                                icon: "exclamationmark.triangle.fill",
                                title: "⚠️ High UV Alert",
                                _body: "UV Index will reach \(String(format: "%.1f", settings.uvThreshold)) at 2:00 PM.\n☀️ Use SPF 30+ sunscreen and wear protective clothing.",
                                color: .red
                            )
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Preview")
                }
                
                // MARK: - Test Section
                Section {
                    Button(action: sendTestNotification) {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                            Text("Send Test Notification")
                        }
                    }
                    
                    Button(action: {
                        notificationManager.printPendingNotifications()
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("View Pending Notifications")
                        }
                    }
                } header: {
                    Text("Testing")
                }
            }
        }
        .navigationTitle("UV Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Notification Permission", isPresented: $showingPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {
                settings.notificationsEnabled = false
            }
        } message: {
            Text("Please enable notifications in Settings to receive UV alerts")
        }
        .alert("Test Notification Sent", isPresented: $showingTestNotification) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Check your notification center in a few seconds")
        }
        .onAppear {
            notificationManager.checkAuthorizationStatus()
        }
    }
    
    // MARK: - Helper Methods
    
    private func requestNotificationPermission() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            if !granted {
                await MainActor.run {
                    showingPermissionAlert = true
                }
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
    
    private func getColorForUV(_ uv: Double) -> Color {
        switch uv {
        case 0..<3: return .green
        case 3..<6: return .yellow
        case 6..<8: return .orange
        case 8..<11: return .red
        default: return .purple
        }
    }
}

// MARK: - Notification Preview Card

struct NotificationPreviewCard: View {
    let icon: String
    let title: String
    let _body: String
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
                
                Text(_body)
                    .font(.caption)
                    .foregroundColor(.secondary)
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
