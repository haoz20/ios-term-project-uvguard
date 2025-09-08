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
        
        // Build URL string with proper encoding
        let plusQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString =
        "https://geocoding-api.open-meteo.com/v1/search?name=\(plusQuery)&count=10&language=en&format=json"
        
        // Cancel any previous request
        inFlight?.cancel()
        errorMessage = nil
        isLoading = true
        
        do {
            // Use async/await instead of closures
            let searchResults: Results = try await AF.request(urlString, method: .get)
                .validate(statusCode: 200..<300)
                .serializingDecodable(Results.self)
                .value
            
            // Direct assignment - no optionals needed
            self.results = searchResults.results
            self.errorMessage = nil
            self.isLoading = false
            
            print("✅ Found \(searchResults.results.count) cities")
            
        } catch {
            // Handle cancellation
            if let afError = error as? AFError,
               case .sessionTaskFailed(let sessionError) = afError,
               (sessionError as NSError).code == NSURLErrorCancelled {
                // Request was cancelled, don't update UI
                return
            }
            
            // Handle other errors
            self.results = []
            self.errorMessage = "No Locations Found"
            self.isLoading = false
            
            print("❌ Search error: \(error)")
        }
    }
}

