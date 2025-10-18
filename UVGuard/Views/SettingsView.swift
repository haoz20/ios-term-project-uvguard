//
//  SettingsView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var notificationSettings = NotificationSettings.shared
    @State private var settingsManager = SettingsManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient.uvBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Settings Card
                        settingsCard
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Settings Card
    private var settingsCard: some View {
        VStack(spacing: 0) {
            // UV Notifications
            NavigationLink {
                NotificationSettingsView()
            } label: {
                HStack {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.uvAccent)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("UV Notifications")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.uvPrimaryText)
                        
                        Text(isNotificationsEnabled ? "Enabled" : "Disabled")
                            .font(.caption)
                            .foregroundColor(.uvSecondaryText)
                    }
                    
                    Spacer()
                    
                    if isNotificationsEnabled {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.uvAccent)
                            .font(.caption)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.uvSecondaryText)
                        .font(.caption)
                }
                .padding()
                .background(Color.uvCardBackground)
            }
            
            Divider()
                .padding(.horizontal)
            
            // 24-hour Time Toggle
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.uvAccent)
                    .frame(width: 24)
                
                Text("24-hour Time")
                    .foregroundColor(.uvPrimaryText)
                
                Spacer()
                
                Toggle("", isOn: $settingsManager.is24HourTime)
                    .tint(.uvAccent)
            }
            .padding()
            .background(Color.uvCardBackground)
            
            Divider()
                .padding(.horizontal)
            
            // Language Selection
            NavigationLink {
                LanguageView(selection: $settingsManager.language)
            } label: {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.uvAccent)
                        .frame(width: 24)
                    
                    Text("Language")
                        .foregroundColor(.uvPrimaryText)
                    
                    Spacer()
                    
                    Text(settingsManager.language.shortLabel)
                        .foregroundColor(.uvSecondaryText)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.uvSecondaryText)
                        .font(.caption)
                }
                .padding()
                .background(Color.uvCardBackground)
            }
            
            Divider()
                .padding(.horizontal)
            
            // Theme/Appearance
            NavigationLink {
                AppearanceView(selection: $settingsManager.appearance)
            } label: {
                HStack {
                    Image(systemName: appearanceIcon)
                        .foregroundColor(.uvAccent)
                        .frame(width: 24)
                    
                    Text("Appearance")
                        .foregroundColor(.uvPrimaryText)
                    
                    Spacer()
                    
                    Text(settingsManager.appearance.rawValue)
                        .foregroundColor(.uvSecondaryText)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.uvSecondaryText)
                        .font(.caption)
                }
                .padding()
                .background(Color.uvCardBackground)
            }
        }
        .cornerRadius(12)
        .modifier(UVCardModifier())
    }
    
    // MARK: - Computed Properties
    private var isNotificationsEnabled: Bool {
        notificationSettings.dailyForecastEnabled || notificationSettings.thresholdNotificationsEnabled
    }
    
    private var appearanceIcon: String {
        switch settingsManager.appearance {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

#Preview {
    SettingsView()
}