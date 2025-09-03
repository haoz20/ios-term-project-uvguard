//
//  AppearanceView.swift
//  UVGuard
//
//  Created by Thiri Htet on 03/09/2025.
//

import SwiftUI

struct AppearanceView: View {
    
    @Binding var selection : AppearanceOption
    
    var body: some View {
        
        List{
            Section{
                ForEach(AppearanceOption.allCases) { option in
                    Button {
                        selection = option
                    }label : {
                        HStack{
                            Text(option.rawValue)
                            Spacer()
                            if selection == option {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                            }
                                
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


enum AppearanceOption : String, CaseIterable, Identifiable {
    case system = "System"
    case dark = "Dark"
    case light = "Light"
    
    var id: String {
        rawValue
    }
    
    var shortLabel : String {
        switch self {
        case .system : return "System"
        case .dark : return "Dark"
        case .light : return "Light"
        }
    }
    
    
}



#Preview {
    AppearanceView(selection: .constant(.system))
}
