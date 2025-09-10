//
//  SettingsView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var notificationsOn = false
    @State private var selectedAppearance: AppearanceOption = .system
    @State private var is24HourTimeOn = false
    @State private var selectedLanguage: LanguageOption = .english
    
    var body: some View {
        NavigationStack {
            Form{
                Toggle("Notification", isOn: $notificationsOn)
                
                Toggle("24-hour Time", isOn: $is24HourTimeOn)
                
                NavigationLink{
                    LanguageView(selection: $selectedLanguage)
                }label : {
                    HStack{
                        Text("Language")
                        Spacer()
                        Text(selectedLanguage.shortLabel)
                            .foregroundStyle(.secondary)
                    }
                }
                
                NavigationLink{
                    AppearanceView(selection: $selectedAppearance)
                }label : {
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
}


#Preview {
    SettingsView()
}
