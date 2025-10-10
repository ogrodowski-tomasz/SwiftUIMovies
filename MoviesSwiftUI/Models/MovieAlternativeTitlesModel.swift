import Foundation

struct MovieAlternativeTitlesResponseModel: Codable {
    let id: Int
    let titles: [MovieAlternativeTitlesModel]
}

struct MovieAlternativeTitlesModel: Codable {
    let iso3166_1, title: String
        let type: String

        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case title, type
        }
}
