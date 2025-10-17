import Foundation

// MARK: - PROTOCOL

protocol MovieNetworkManagerProtocol {
    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T
}

extension MovieNetworkManagerProtocol {
    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = .convertFromSnakeCase) async throws -> T {
        try await load(endpoint: endpoint, decodeToType: type, keyDecodingStrategy: keyDecodingStrategy)
    }

}

// MARK: - IMPLEMENTATION

struct MovieNetworkManager: MovieNetworkManagerProtocol {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: MovieEndpoint, decodeToType type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T {
        return try await httpClient.load(endpoint, modelType: type, keyDecodingStrategy: keyDecodingStrategy)
    }
}

// MARK: - MOCK MANAGER

struct MockMovieNetworkManager: MovieNetworkManagerProtocol {
    func load<T>(endpoint: MovieEndpoint, decodeToType type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T where T : Decodable, T : Encodable {
        guard let filename = endpoint.stubDataFilename else {
            throw NetworkError.invalidURL
        }
        return try StaticJSONMapper.decode(file: filename, type: T.self, keyDecodingStrategy: keyDecodingStrategy)
    }
}
