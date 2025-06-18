import SwiftData
import SwiftUI

struct MovieListScreen: View {

    // MARK: - ENVIRONMENT
    @Environment(\.showError) private var showError
    @Environment(MovieStore.self) var movieStore
    @Environment(Router.self) var router

    // MARK: - BODY
    var body: some View {
        List {
            if let nowPlaying = movieStore.nowPlaying {
                MovieListView(movies: nowPlaying, sectionTitle: "Now playing")
            }
            if let topRated = movieStore.topRated {
                MovieListView(movies: topRated, sectionTitle: "Top Rated")
            }
            if let popular = movieStore.popular {
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
            async let topRated: () = movieStore.loadTopRatedMovies()
            async let popular: () = movieStore.loadPopularMovies()
            async let nowPlaying: () = movieStore.loadNowPlayingMovies()
            _ = try await (topRated, popular, nowPlaying)
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
            .environment(MovieStore(movieNetworkManager: MockMovieNetworkManager()))
            .environment(Router())
    }
}
