import Foundation

protocol SearchNetworkManagerProtocol {
    func load<T: Codable>(endpoint: SearchEndpoint, decodeToType type: T.Type) async throws -> T
}

struct SearchNetworkManager: SearchNetworkManagerProtocol {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: SearchEndpoint, decodeToType type: T.Type) async throws -> T {
        return try await httpClient.load(endpoint, modelType: type, keyDecodingStrategy: .convertFromSnakeCase)
    }
}

// MARK: - MOCK MANAGER

struct MockSearchNetworkManager: SearchNetworkManagerProtocol {
    
    func load<T: Codable>(endpoint: SearchEndpoint, decodeToType type: T.Type) async throws -> T {
        guard let filename = endpoint.stubDataFilename else {
            throw NetworkError.invalidURL
        }

        return try StaticJSONMapper.decode(file: filename, type: T.self)
    }
}
