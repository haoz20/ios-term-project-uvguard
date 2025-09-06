//
//  CitiesView.swift
//  UVGuard
//
//  Created by Swan Htet Aung on 4/9/25.
//

import SwiftUI

struct CitiesView: View {
    
    @State private var showAddCity = false
    @State private var cities: [CityModel] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if cities.isEmpty {
                    ContentUnavailableView(
                        "No Cities Added",
                        systemImage: "location.slash",
                        description: Text("Add cities to see UV index information for multiple locations.")
                    )
                } else {
                    List {
                        ForEach(cities) { city in
                            VStack(alignment: .leading) {
                                Text(city.name).font(.headline)
                                if let country = city.country, !country.isEmpty {
                                    Text(country).font(.caption).foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteCities)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Cities")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCity = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.app")
                        }
                        
                    }
                }
            }
            .sheet(isPresented: $showAddCity) {
                SearchCityView(saveCity: { city in
                    addCity(city)
                })
            }
            .onAppear {
                loadCities()
            }
        }
        
        
        
    }
    
    private func loadCities() {
        if let data = UserDefaults.standard.object(forKey: "favorite-cities") as? Data {
            do {
                let savedCities = try JSONDecoder().decode([CityModel].self, from: data)
                cities = savedCities
            } catch {
                
            }
        }
    }
    
    private func saveCities() {
        do {
            let encoder = JSONEncoder()
            let saveCities = try encoder.encode(cities)
            UserDefaults.standard.set(saveCities, forKey: "favorite-cities")
        } catch {
            
        }
    }
    
    
    private func addCity(_ city: CityModel) {
        if !cities.contains(where: { $0.id == city.id }) {
            cities.append(city)
        }
        saveCities()
    }
    
    private func deleteCities(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
        saveCities()
    }
    
}

#Preview {
    CitiesView()
}
