import SwiftData
import SwiftUI

struct MovieListScreen: View {

    // MARK: - ENVIRONMENT
    @Environment(\.showError) private var showError
    @Environment(Router.self) var router
    @Environment(\.httpClient) var httpClient
    
    @State private var topRated: [MovieApiModel]? = nil
    @State private var popular: [MovieApiModel]? = nil
    @State private var nowPlaying: [MovieApiModel]? = nil

    // MARK: - BODY
    var body: some View {
        List {
            if let nowPlaying = nowPlaying {
                MovieListView(movies: nowPlaying, sectionTitle: "Now playing")
            }
            if let topRated = topRated {
                MovieListView(movies: topRated, sectionTitle: "Top Rated")
            }
            if let popular = popular {
                MovieListView(movies: popular, sectionTitle: "Popular")
            }
        }
        .inlineNavigationTitle("Movie List")
        .task {
            await loadData()
        }
    }

    // MARK: - METHODS

    /// Loads multiple categories of movies concurrently to improve performance.
    ///
    /// Using `async let` allows all API calls to run in parallel instead of sequentially.
    /// This reduces the total waiting time, since the calls are independent of each other.
    ///
    /// The method waits for all calls to complete before updating the UI or proceeding further.
    ///
    /// When error is catched user is let to retry this method.
    private func loadData() async {
        do {
            async let fetchedPopular = httpClient.load(.popular, modelType: MovieApiResponseModel.self)
            async let fetchedTopRated = httpClient.load(.topRated, modelType: MovieApiResponseModel.self)
            async let fetchedNowPlaying = httpClient.load(.nowPlaying, modelType: MovieApiResponseModel.self)
            let fetchedData = try await (fetchedTopRated, fetchedPopular, fetchedNowPlaying)
            self.topRated = Array(fetchedData.0.results.prefix(5))
            self.popular = Array(fetchedData.1.results.prefix(5))
            self.nowPlaying = Array(fetchedData.2.results.prefix(5))
        } catch {
            showError(error, "Failed to load movies") {
                Task {
                    await loadData()
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    NavigationStack {
        MovieListScreen()
            .environment(Router())
            .environment(\.httpClient, MockHTTPClient())
    }
}
