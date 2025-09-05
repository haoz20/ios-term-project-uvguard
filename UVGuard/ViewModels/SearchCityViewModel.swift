import Foundation
import Observation
import Alamofire

@MainActor
@Observable
final class SearchCityViewModel {

    // UI state
    var results: [CityModel] = []
    var isLoading = false
    var errorMessage: String?

    // Keep a reference to cancel in-flight requests when user keeps typing
    private var inFlight: DataRequest?
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    /// Public entry point from the View
    func search(_ rawQuery: String) async {
        let query = rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            // Reset when empty
            results = []
            errorMessage = nil
            return
        }

        // Build URL string with spaces -> '+'
        let plusQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString =
          "https://geocoding-api.open-meteo.com/v1/search?name=\(plusQuery)&count=10&language=en&format=json"

        // Cancel any previous request
        inFlight?.cancel()
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let req = session.request(urlString, method: .get)
            inFlight = req

            // Decode directly into your CityModel list via a small DTO
            struct APIResponse: Decodable { let results: [CityModel]? }

            let response = try await req
                .serializingDecodable(APIResponse.self)
                .value

            self.results = response.results ?? []
        } catch {
            // Ignore explicit cancel errors (caused by rapid typing)
            if let afErr = error as? AFError, afErr.isExplicitlyCancelledError {
                return
            }
            self.results = []
            self.errorMessage = error.localizedDescription
        }
    }
}
