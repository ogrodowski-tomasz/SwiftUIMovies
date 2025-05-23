import Foundation

struct CollectionDetailsApiModel: Codable {
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [CollectionPartsApiModel]
}

struct CollectionPartsApiModel: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
}
