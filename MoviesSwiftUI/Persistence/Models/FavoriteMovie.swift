import Foundation
import SwiftData

@Model
final class FavoriteMovie {

    @Attribute(.unique) var id: Int
    var title: String = "Unknown"
    var posterPath: String? = nil
    var releaseDate: String? = nil
    var voteAverage: Double? = nil

    init(id: Int, title: String = "Unknown", posterPath: String? = nil, releaseDate: String? = nil, voteAverage: Double? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}

extension FavoriteMovie: MovieListRepresentable { }
