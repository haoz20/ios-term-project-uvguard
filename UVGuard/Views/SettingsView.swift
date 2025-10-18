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
                        // MARK: - UV Notifications Section
                        notificationSection
                        
                        // MARK: - General Settings Section
                        generalSettingsSection
                        
                        // MARK: - Appearance Section
                        appearanceSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Notification Section
    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bell.badge.fill")
                    .foregroundColor(isNotificationsEnabled ? .uvAccent : .uvSecondaryText)
                    .font(.title3)
                
                Text("Notifications")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            NavigationLink {
                NotificationSettingsView()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("UV Notifications")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.uvPrimaryText)
                        
                        if isNotificationsEnabled {
                            Text("Enabled")
                                .font(.caption)
                                .foregroundColor(.uvSecondaryText)
                        } else {
                            Text("Disabled")
                                .font(.caption)
                                .foregroundColor(.uvSecondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if isNotificationsEnabled {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.uvAccent)
                            .font(.body)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.uvSecondaryText)
                        .font(.caption)
                }
                .padding()
                .background(Color.uvCardBackground)
                .cornerRadius(12)
            }
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - General Settings Section
    private var generalSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.uvAccent)
                    .font(.title3)
                
                Text("General")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                // 24-hour Time Toggle
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.uvAccent)
                        .frame(width: 24)
                    
                    Text("24-hour Time")
                        .uvPrimaryText()
                    
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
            }
            .cornerRadius(12)
        }
        .padding()
        .modifier(UVCardModifier())
    }
    
    // MARK: - Appearance Section
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .foregroundColor(.uvAccent)
                    .font(.title3)
                
                Text("Appearance")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .uvPrimaryText()
                
                Spacer()
            }
            
            NavigationLink {
                AppearanceView(selection: $settingsManager.appearance)
            } label: {
                HStack {
                    Image(systemName: appearanceIcon)
                        .foregroundColor(.uvAccent)
                        .frame(width: 24)
                    
                    Text("Theme")
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
                .cornerRadius(12)
            }
        }
        .padding()
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

#Preview {
    SettingsView()
}