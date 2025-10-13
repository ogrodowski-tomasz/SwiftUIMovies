import Foundation

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var modelType: T.Type
    var stubFileName: String?
    
    init(url: URL, method: HTTPMethod = .get([]), modelType: T.Type) {
        self.url = url
        self.method = method
        self.modelType = modelType
        self.stubFileName = nil
    }
    
    init(endpoint: MovieEndpoint, modelType: T.Type) throws {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        self.url = url
        self.method = .get([])
        self.modelType = modelType
        self.stubFileName = endpoint.stubDataFilename
    }
}
