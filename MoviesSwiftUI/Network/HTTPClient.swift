import Foundation
import SwiftUI

protocol HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T
}

extension HTTPClientProtocol {
    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = .convertFromSnakeCase) async throws -> T {
        try await load(resource, keyDecodingStrategy: keyDecodingStrategy)
    }
    
    func load<T: Codable>(_ endpoint: MovieEndpoint, modelType: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = .convertFromSnakeCase) async throws -> T {
        let resource = try Resource(endpoint: endpoint, modelType: modelType)
        return try await load(resource, keyDecodingStrategy: keyDecodingStrategy)
    }
}

private struct HTTPClientKey: EnvironmentKey {
    static var defaultValue: HTTPClientProtocol = HTTPClient()
}

extension EnvironmentValues {
    var httpClient: HTTPClientProtocol {
        get { self[HTTPClientKey.self] }
        set { self[HTTPClientKey.self] = newValue }
    }
}

struct HTTPClient: HTTPClientProtocol {

    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json", "Authorization": "Bearer \(AppKey.apiKey)"]
        self.session = URLSession(configuration: configuration)
    }

    func load<T: Codable>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) async throws -> T {

        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.name


        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }

            request = URLRequest(url: url)

        case .post(let data):
            request.httpBody = data

        case .delete:
            break
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
//            let jsonObject = try JSONSerialization.jsonObject(with: data)
//            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//            let prettyString = String(data: prettyData, encoding: .utf8) ?? ""
//            
//            print("DEBUG: JSON for url \(resource.url): \(prettyString)")
            
            let decoder = JSONDecoder()
            if let keyDecodingStrategy {
                decoder.keyDecodingStrategy = keyDecodingStrategy
            }
            let result = try decoder.decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

}

struct MockHTTPClient: HTTPClientProtocol {
    
    func load<T>(_ resource: Resource<T>, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy?) async throws -> T where T : Decodable, T : Encodable {
        guard let filename = resource.stubFileName else {
            throw NetworkError.invalidURL
        }
        return try StaticJSONMapper.decode(file: filename, type: T.self, keyDecodingStrategy: keyDecodingStrategy)
    }
}

