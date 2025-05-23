import Foundation

struct StaticJSONMapper {

    static func decode<T: Decodable>(file: String, type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {

        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            throw NetworkError.invalidURL
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        return try decoder.decode(T.self, from: data)
    }
}
