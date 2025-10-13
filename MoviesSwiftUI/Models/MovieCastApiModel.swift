import Foundation

struct MovieCastApiResponseModel: Codable {
    let id: Int
    let cast: [MovieCastApiModel]
    let crew: [MovieCastApiModel]
    
    var crewSorted: [MovieCastApiModel] {
        crew.mergedById()
    }
}

struct MovieCastApiModel: Codable, Identifiable, Hashable {
    let adult: Bool?
    let id: Int
    let name: String
    let profilePath: String?
    let character: String?
    let knownForDepartment: String?
    let popularity: Double?
    let job: String?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
