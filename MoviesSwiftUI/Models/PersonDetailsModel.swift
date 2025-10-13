import Foundation

struct PersonDetailsModel: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String
    let deathday: String?
    let gender: Int
    let id: Int
    let name: String
    let popularity: Double
    let profilePath: String?
}
