import SwiftUI

struct SearchCityView: View {
    @State private var text: String = ""
    @State private var vm = SearchCityViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Searching…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let msg = vm.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle").font(.largeTitle)
                        Text("Something went wrong").font(.headline)
                        Text(msg).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.results.isEmpty, !text.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Try a different keyword.")
                    )
                } else {
                    List(vm.results) { city in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(city.name).font(.body)
                            HStack(spacing: 8) {
                                Text(city.country)
//                                if let tz = city.timeZone, !tz.isEmpty {
//                                    Text(tz).foregroundStyle(.secondary)
//                                }
                            }
                            .font(.caption)
                        }
                    }
                    .listStyle(.plain)
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
        }
    }
}

#Preview {
    SearchCityView()
}

