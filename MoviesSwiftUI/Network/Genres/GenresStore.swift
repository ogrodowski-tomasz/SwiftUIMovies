import Foundation

@Observable
final class GenresStore {

    var genreList = [GenreApiModel]()

    let genresNetworkManager: GenreListNetworkManagerProtocol

    init(genresNetworkManager: GenreListNetworkManagerProtocol) {
        self.genresNetworkManager = genresNetworkManager
    }

    func loadAllMovieGenres() async throws {
        genreList = try await genresNetworkManager.load(endpoint: .movieList, decodeToType: GenreListApiResponseModel.self).genres
    }

    func getGenreName(forGenreId id: Int) -> String? {
        guard !genreList.isEmpty else {
            return nil
        }
        return genreList.first(where: { $0.id == id })?.name
    }
}
