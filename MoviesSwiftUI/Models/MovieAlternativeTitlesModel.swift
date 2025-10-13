import Foundation

struct MovieAlternativeTitlesResponseModel: Codable {
    let id: Int
    let titles: [MovieAlternativeTitlesModel]
}

struct MovieAlternativeTitlesModel: Codable, Identifiable, Hashable {
    let iso3166_1: String
    let title: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case title, type
    }
    
    var id: UUID = UUID()
    
    var emoji: String {
        iso3166_1.flagEmoji
    }
}
extension MovieAlternativeTitlesModel {
    static let stubList: [MovieAlternativeTitlesModel] = [
        .init(iso3166_1: "US", title: "The Conjuring 4", type: ""),
        .init(iso3166_1: "SA", title: "الشعوذة: الطقوس الأخيرة", type: ""),
        .init(iso3166_1: "HK", title: "詭屋驚凶實錄4：最後的儀式", type: "")
    ]
}

