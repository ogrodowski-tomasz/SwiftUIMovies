import SwiftData
import SwiftUI

struct MainListScreen: View {
    
    struct MainListState {
        private let limiter: Int = 5
        
        var topRated: [MovieApiModel]? = nil
        var popular: [MovieApiModel]? = nil
        var nowPlaying: [MovieApiModel]? = nil
        
        var topRatedToPresent: [MovieApiModel]? {
            guard let topRated else { return nil }
            guard topRated.count > limiter else { return topRated }
            return Array(topRated.prefix(limiter))
        }
        
        var canTopRatedShowMore: Bool {
            return (topRated?.count ?? 0) > limiter
        }
        
        var popularToPresent: [MovieApiModel]? {
            guard let popular else { return nil }
            guard popular.count > limiter else { return popular }
            return Array(popular.prefix(limiter))
        }
        
        var canPopularShowMore: Bool {
            return (popular?.count ?? 0) > limiter
        }
        
        var nowPlayingToPresent: [MovieApiModel]? {
            guard let nowPlaying else { return nil }
            guard nowPlaying.count > limiter else { return nowPlaying }
            return Array(nowPlaying.prefix(limiter))
        }
        
        var canNowPlayingShowMore: Bool {
            return (nowPlaying?.count ?? 0) > limiter
        }
        
    }

    // MARK: - ENVIRONMENT
    @Environment(\.showError) private var showError
    @Environment(Router.self) var router
    @Environment(\.httpClient) var httpClient
    
    @State private var state: MainListState = .init()

    
    // MARK: - BODY
    var body: some View {
        List {
            if let nowPlayingToPresent = state.nowPlayingToPresent {
                MainListSectionView(
                    movies: nowPlayingToPresent,
                    sectionTitle: "Now playing",
                    showMoreButton: state.canNowPlayingShowMore,
                    onShowMoreTapped: {
                        let allMovies: [MovieApiModel] = state.nowPlaying ?? nowPlayingToPresent
                        router.navigate(
                            to: .moreMovies(
                                initial: allMovies,
                                listType: .nowPlaying
                            )
                        )
                    }
                )
            }
            if let topRatedToPresent = state.topRatedToPresent {
                MainListSectionView(
                    movies: topRatedToPresent,
                    sectionTitle: "Top Rated",
                    showMoreButton: state.canTopRatedShowMore,
                    onShowMoreTapped: {
                    let allMovies: [MovieApiModel] = state.topRated ?? topRatedToPresent
                        router.navigate(
                            to: .moreMovies(
                                initial: allMovies,
                                listType: .topRated
                            )
                        )
                })
            }
            if let popularToPresent = state.popularToPresent {
                MainListSectionView(
                    movies: popularToPresent,
                    sectionTitle: "Popular",
                    showMoreButton: state.canPopularShowMore,
                    onShowMoreTapped: {
                    let allMovies: [MovieApiModel] = state.popular ?? popularToPresent
                        router.navigate(
                            to: .moreMovies(
                                initial: allMovies,
                                listType: .popular
                            )
                        )
                })
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
            async let fetchedPopular = httpClient.load(MovieEndpoint.popular(page: 1), modelType: MovieApiResponseModel.self, keyDecodingStrategy: .convertFromSnakeCase)
            async let fetchedTopRated = httpClient.load(MovieEndpoint.topRated(page: 1), modelType: MovieApiResponseModel.self, keyDecodingStrategy: .convertFromSnakeCase)
            async let fetchedNowPlaying = httpClient.load(MovieEndpoint.nowPlaying(page: 1), modelType: MovieApiResponseModel.self, keyDecodingStrategy: .convertFromSnakeCase)
            let fetchedData = try await (fetchedTopRated, fetchedPopular, fetchedNowPlaying)
            self.state.topRated = fetchedData.0.results
            self.state.popular = fetchedData.1.results
            self.state.nowPlaying = fetchedData.2.results
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
        MainListScreen()
            .environment(Router())
            .environment(\.httpClient, MockHTTPClient())
    }
}
