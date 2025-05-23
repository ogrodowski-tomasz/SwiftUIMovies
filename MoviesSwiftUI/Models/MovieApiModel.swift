import Foundation

protocol MovieListRepresentable: Identifiable {
    var id: Int { get }
    var title: String { get }
    var posterPath: String? { get }
    var releaseDate: String? { get }
    var voteAverage: Double? { get }
}

struct MovieApiResponseModel: Codable {
    let page: Int
    let results: [MovieApiModel]
}

struct MovieApiModel: Codable, Identifiable, Hashable, MovieListRepresentable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int
    let originalLanguage: String?
    let originalTitle: String
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let title: String
    let releaseDate: String?
    let voteAverage: Double?
}
