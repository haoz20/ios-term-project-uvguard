//
//  LanguageView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct LanguageView: View {
    
    @Binding var selection: LanguageOption
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.uvBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(LanguageOption.allCases) { option in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = option
                            }
                        } label: {
                            HStack {
                                // Flag emoji
                                Text(option.flag)
                                    .font(.title2)
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(option.rawValue)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.uvPrimaryText)
                                    
                                    Text(option.nativeName)
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
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum LanguageOption: String, CaseIterable, Identifiable, Codable {
    case english = "English"
    case chinese = "Chinese"
    case burmese = "Burmese"
    
    var id: String {
        rawValue
    }
    
    var shortLabel: String {
        rawValue
    }
    
    var flag: String {
        switch self {
        case .english:
            return "🇺🇸"
        case .chinese:
            return "🇨🇳"
        case .burmese:
            return "🇲🇲"
        }
    }
    
    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .chinese:
            return "中文"
        case .burmese:
            return "မြန်မာ"
        }
    }
}

#Preview {
    LanguageView(selection: .constant(.english))
}
