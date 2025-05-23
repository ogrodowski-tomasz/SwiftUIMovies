import Foundation

struct GenreListApiResponseModel: Codable {
    let genres: [GenreApiModel]
}

struct GenreApiModel: Codable, Identifiable {
    let id: Int
    let name: String
}
