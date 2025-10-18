//
//  AppearanceView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct AppearanceView: View {
    
    @Binding var selection: AppearanceOption
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(AppearanceOption.allCases) { option in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = option
                            }
                        } label: {
                            HStack {
                                // Icon
                                Image(systemName: option.icon)
                                    .foregroundColor(selection == option ? .uvAccent : .uvSecondaryText)
                                    .font(.title3)
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(option.rawValue)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.uvPrimaryText)
                                    
                                    Text(option.description)
                                        .font(.caption)
                                        .foregroundColor(.uvSecondaryText)
                                }
                                
                                Spacer()
                                
                                if selection == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.uvAccent)
                                        .font(.title3)
                                }
                            }
                            .padding()
                            .background(Color.uvCardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selection == option ? Color.uvAccent : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}


enum AppearanceOption: String, CaseIterable, Identifiable, Codable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String {
        rawValue
    }
    
    var shortLabel: String {
        rawValue
    }
    
    var icon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    var description: String {
        switch self {
        case .system:
            return "Match system settings"
        case .light:
            return "Light mode"
        case .dark:
            return "Dark mode"
        }
    }
}



#Preview {
    AppearanceView(selection: .constant(.system))
}
