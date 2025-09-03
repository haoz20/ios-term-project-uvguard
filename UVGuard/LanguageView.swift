//
//  LanguageView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct LanguageView: View {
    
    @Binding var selection : LanguageOption
    
    var body: some View {
        List{
            Section("Language"){
                ForEach(LanguageOption.allCases) { option in
                    Button {
                        selection = option
                    }label: {
                        HStack{
                            Text(option.rawValue)
                            Spacer()
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                            }
                        }
                    }
                    .foregroundColor(.primary)
                    
                }
            }
        }
        .navigationTitle("Language")
    }
}

enum LanguageOption : String, CaseIterable, Identifiable {
    case english = "English"
    case chinese = "Chinese"
    case burmese = "Burmese"
    
    var id: String {
        rawValue
    }
    
    var shortLabel : String {
        switch self {
        case .english : return "English"
        case .burmese : return "Burmese"
        case .chinese : return "Chinese"
        }
    }
}

#Preview {
    LanguageView(selection: .constant(.english))
}
