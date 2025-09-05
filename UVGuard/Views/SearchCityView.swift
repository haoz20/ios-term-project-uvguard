//
//  SearchCityView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 5/9/25.
//

import SwiftUI

struct SearchCityView: View {
    
    @State private var searchCity: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .navigationTitle("Search City")
            .searchable(text: $searchCity, prompt: "Enter city or country")
        }
    }
}

#Preview {
    SearchCityView()
}
