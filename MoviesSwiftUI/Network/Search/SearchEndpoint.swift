import Foundation

enum SearchEndpoint {
    case movie(query: String)
}

extension SearchEndpoint: AppEndpoint {
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .movie:
            return "/3/search/movie"
        }
    }
    
    var stubDataFilename: String? {
        switch self {
        case .movie:
            return "SearchStubData"
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        switch self {
        case .movie(let query):
            components.queryItems = [URLQueryItem(name: "query", value: query)]
        }
        return components.url
    }
    
    var method: String {
        "GET"
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .movie(let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }
}
