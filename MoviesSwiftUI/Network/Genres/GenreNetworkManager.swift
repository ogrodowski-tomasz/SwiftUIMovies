import Foundation

protocol GenreListNetworkManagerProtocol {
    func load<T: Codable>(endpoint: GenreEndpoint, decodeToType type: T.Type) async throws -> T
}

struct GenreListNetworkManager {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: GenreEndpoint, decodeToType type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        let resource = Resource(url: url, modelType: T.self)
        return try await httpClient.load(resource, keyDecodingStrategy: .convertFromSnakeCase)
    }
}
