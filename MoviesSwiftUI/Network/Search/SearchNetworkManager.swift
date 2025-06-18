import Foundation

protocol SearchNetworkManagerProtocol {
    func load<T: Codable>(endpoint: SearchEndpoint, decodeToType type: T.Type) async throws -> T
}

struct SearchNetworkManager: SearchNetworkManagerProtocol {

    let httpClient: HTTPClientProtocol

    func load<T: Codable>(endpoint: SearchEndpoint, decodeToType type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        var queryItems = [URLQueryItem]()
        switch endpoint {
        case .movie(let query):
            queryItems.append(.init(name: "query", value: query))
        }
        let resource = Resource(url: url, method: .get(queryItems), modelType: T.self)
        return try await httpClient.load(resource, keyDecodingStrategy: .convertFromSnakeCase)
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
