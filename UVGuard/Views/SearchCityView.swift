import SwiftUI

struct SearchCityView: View {
    @State private var text: String = ""
    @State private var vm = SearchCityViewModel()
    var saveCity: (CityModel) -> Void = { _ in }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Warm background gradient
                LinearGradient.uvBackground
                    .ignoresSafeArea()
                
                Group {
                    if vm.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.uvAccent)
                            Text("Searching…")
                                .font(.uvHeadline)
                                .uvSecondaryText()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let msg = vm.errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.montserratBold(50))
                                .foregroundColor(.uvDanger)
                            Text("Something went wrong")
                                .font(.uvHeadline)
                                .uvPrimaryText()
                            Text(msg)
                                .uvSecondaryText()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if vm.results.isEmpty, !text.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.montserratBold(50))
                                .foregroundColor(.uvAccent)
                            Text("No Results")
                                .font(.uvHeadline)
                                .uvPrimaryText()
                            Text("Try a different keyword.")
                                .uvSecondaryText()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if !vm.results.isEmpty {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(vm.results) { city in
                                    Button {
                                        saveCity(city)
                                        dismiss()
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(city.name)
                                                    .font(.uvHeadline)
                                                    .uvPrimaryText()
                                                
                                                HStack(spacing: 8) {
                                                    if let country = city.country, !country.isEmpty {
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "location.fill")
                                                                .font(.uvCaption2)
                                                                .foregroundColor(.uvAccent)
                                                            Text(country)
                                                        }
                                                    }
                                                    if let timeZone = city.timeZone, !timeZone.isEmpty, timeZone != city.country {
                                                        HStack(spacing: 4) {
                                                            Image(systemName: "clock.fill")
                                                                .font(.uvCaption2)
                                                                .foregroundColor(.uvAccent)
                                                            Text(timeZone)
                                                        }
                                                    }
                                                }
                                                .font(.uvCaption)
                                                .uvSecondaryText()
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.uvCaption)
                                                .foregroundColor(.uvAccent)
                                        }
                                        .padding()
                                        .background(Color.uvCardBackground.opacity(0.5))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $text, prompt: "Enter city or country")
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            // Debounce the input to avoid spamming the API
            .task(id: text) {
                let q = text
                try? await Task.sleep(nanoseconds: 350_000_000) // ~350ms
                guard q == text else { return } // ignore stale
                await vm.search(q)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.uvAccent)
                }
            }
        }
    }
}

#Preview {
    SearchCityView()
}

