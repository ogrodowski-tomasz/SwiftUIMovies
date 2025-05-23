import Foundation

struct MovieDetailsApiModel: Codable, MovieListRepresentable {
    let adult: Bool
    let backdropPath: String?
    let genres: [GenreApiModel]
    let id: Int
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let tagline: String?
    let title: String
    let voteAverage: Double?
    let belongsToCollection: MovieCollectionApiModel?
}

struct MovieCollectionApiModel: Codable, Identifiable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
}
