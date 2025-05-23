import Foundation
import FirebaseAuth


protocol AuthDataResultModelProtocol {
    var uid: String { get }
    var email: String? { get }
    var displayName: String? { get }
}

struct UserModel: Codable {
    let id: String
    let email: String
    let name: String

    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }

    init(auth: AuthDataResultModelProtocol) {
        self.email = auth.email ?? ""
        self.name = auth.displayName ?? ""
        self.id = auth.uid
    }

    init(user: User) {
        self.id = user.uid
        self.email = user.email ?? ""
        self.name = user.displayName ?? ""
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case name = "name"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.name, forKey: .name)
    }
}
