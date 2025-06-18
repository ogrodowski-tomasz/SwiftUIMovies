import Combine
import SwiftUI

struct SearchScreen: View {
    @Environment(\.showError) private var showError
    
    @State private var searchResults: [MovieApiModel]? = nil
    @State private var searchText: String = ""
    @State private var isPerformingNetworkOperations = false
    
    private let searchNetworkManager: SearchNetworkManagerProtocol
        
    init(searchNetworkManager: SearchNetworkManagerProtocol) {
        self.searchNetworkManager = searchNetworkManager
    }

    var body: some View {
        Group {
            if let searchResults {
                SearchView(searchResults: searchResults, searchText: searchText)
            } else {
                Text("Start searching for movies...")
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: "Search movies")
        .onSubmit(of: .search) {
            searchSubmitted(searchText)
        }
        .withProgressView(show: $isPerformingNetworkOperations)
        .inlineNavigationTitle("Search")
    }
    
    private func searchSubmitted(_ queryText: String) {
        guard !queryText.isEmpty else {
            searchResults = nil
            return
        }
        Task {
           await loadSearchResults(queryText)
        }
    }
    
    private func loadSearchResults(_ queryText: String) async {
        isPerformingNetworkOperations = true
        defer { isPerformingNetworkOperations = false }
        do {
            let fetchedResults = try await searchNetworkManager.load(endpoint: .movie(query: queryText), decodeToType: MovieApiResponseModel.self).results.sorted { $0.popularity ?? -1 > $1.popularity ?? -1 }
            searchResults = fetchedResults
        } catch {
            print("Loading search results for searchText \"\(queryText)\" failed with error:\(error)")
            showError(error, "Searching for \"\(queryText)\" failed", nil)
        }
    }
}

struct SearchView: View {
    @Environment(Router.self) var router
    
    let searchResults: [MovieApiModel]
    let searchText: String
    
    var body: some View {
        List {
            if searchResults.isEmpty {
                Text("No results found for \"\(searchText)\"")
            } else {
                Section("Search results for: \"\(searchText)\"") {
                    ForEach(searchResults, id: \.id) { movie in
                        Button {
                            router.navigate(to: .movieDetails(id: movie.id))
                        } label: {
                            MovieCardView(movie: movie, review: nil)
                        }
                        .tint(.black)
                    }
                }
            }
        }
    }
}


#Preview {
    SearchScreen(searchNetworkManager: MockSearchNetworkManager())
}
