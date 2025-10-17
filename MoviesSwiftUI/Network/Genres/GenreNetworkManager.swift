import Foundation

protocol GenreListNetworkManagerProtocol {
    func load<T: Codable>(endpoint: GenreEndpoint, decodeToType type: T.Type) async throws -> T
}

struct GenreListNetworkManager {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: GenreEndpoint, decodeToType type: T.Type) async throws -> T {
        return try await httpClient.load(endpoint, modelType: type, keyDecodingStrategy: .convertFromSnakeCase)
    }
}
