import Foundation

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete

    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}
