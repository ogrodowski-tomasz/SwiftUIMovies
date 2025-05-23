import Foundation

/// Source of truth about movies
///
/// This object stores state of fetched movies data.
/// You can use load methods in order to update this state
@Observable
final class MovieStore {

    var topRated: [MovieApiModel]? = nil
    var popular: [MovieApiModel]? = nil
    var nowPlaying: [MovieApiModel]? = nil

    let movieNetworkManager: MovieNetworkManagerProtocol

    init(movieNetworkManager: MovieNetworkManagerProtocol) {
        self.movieNetworkManager = movieNetworkManager
    }

    func loadTopRatedMovies() async throws {
        let fetched = try await movieNetworkManager.load(endpoint: .topRated, decodeToType: MovieApiResponseModel.self).results
        topRated = Array(fetched.prefix(5))
    }

    func loadPopularMovies() async throws {
        let fetched = try await movieNetworkManager.load(endpoint: .popular, decodeToType: MovieApiResponseModel.self).results
        popular = Array(fetched.prefix(5))
    }

    func loadNowPlayingMovies() async throws {
        let fetched = try await movieNetworkManager.load(endpoint: .nowPlaying, decodeToType: MovieApiResponseModel.self).results
        nowPlaying = Array(fetched.prefix(5))
    }

    func loadDetails(for id: Int) async throws -> MovieDetailsApiModel {
        return try await movieNetworkManager.load(endpoint: .movieDetails(id: id), decodeToType: MovieDetailsApiModel.self)
    }

    func loadCast(for id: Int) async throws -> MovieCastApiResponseModel {
        return try await movieNetworkManager.load(endpoint: .cast(movieId: id), decodeToType: MovieCastApiResponseModel.self)
    }
}
