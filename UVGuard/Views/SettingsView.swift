//
//  SettingsView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var notificationSettings = NotificationSettings.shared
    @State private var selectedAppearance: AppearanceOption = .system
    @State private var is24HourTimeOn = false
    @State private var selectedLanguage: LanguageOption = .english
    
    var body: some View {
        NavigationStack {
            Form {
                // UV Notifications Section
                NavigationLink {
                    NotificationSettingsView()
                } label: {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(isNotificationsEnabled ? .blue : .secondary)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("UV Notifications")
                            if isNotificationsEnabled {
                                Text("Enabled")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if isNotificationsEnabled {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
                
                Toggle("24-hour Time", isOn: $is24HourTimeOn)
                
                NavigationLink {
                    LanguageView(selection: $selectedLanguage)
                } label: {
                    HStack {
                        Text("Language")
                        Spacer()
                        Text(selectedLanguage.shortLabel)
                            .foregroundStyle(.secondary)
                    }
                }
                
                NavigationLink {
                    AppearanceView(selection: $selectedAppearance)
                } label: {
                    HStack {
                        Text("Appearance")
                        Spacer()
                        Text(selectedAppearance.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Computed property to check if any notifications are enabled
    private var isNotificationsEnabled: Bool {
        notificationSettings.dailyForecastEnabled || notificationSettings.thresholdNotificationsEnabled
    }
}

#Preview {
    SettingsView()
}