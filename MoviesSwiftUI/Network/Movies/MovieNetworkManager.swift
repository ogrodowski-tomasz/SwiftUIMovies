import Foundation

// MARK: - PROTOCOL

protocol MovieNetworkManagerProtocol {
    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type) async throws -> T
}

// MARK: - IMPLEMENTATION

struct MovieNetworkManager: MovieNetworkManagerProtocol {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        let resource = Resource(url: url, modelType: T.self)
        return try await httpClient.load(resource, keyDecodingStrategy: .convertFromSnakeCase)
    }
}

// MARK: - MOCK MANAGER

struct MockMovieNetworkManager: MovieNetworkManagerProtocol {

    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type) async throws -> T {
        guard let filename = endpoint.stubDataFilename else {
            throw NetworkError.invalidURL
        }

        return try StaticJSONMapper.decode(file: filename, type: T.self)
    }
}
