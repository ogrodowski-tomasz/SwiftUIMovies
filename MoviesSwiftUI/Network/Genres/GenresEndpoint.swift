import Foundation

enum GenreEndpoint {
    case movieList
}

extension GenreEndpoint: AppEndpoint {

    var scheme: String {
        "https"
    }

    var host: String {
        "api.themoviedb.org"
    }

    var baseURL: String {
        "https://api.themoviedb.org/3/"
    }

    var path: String {
        switch self {
        case .movieList:
            return "/3/genre/movie/list"
        }
    }

    var stubDataFilename: String? {
        switch self {
        case .movieList:
            return "GenresListStubData"
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        // TODO: Add queryItems handling for page or lang
        // language=en-US&page=1
//        components.queryItems = [
//            URLQueryItem(name: "language", value: "en-US"),
//            URLQueryItem(name: "page", value: "1"),
//        ]
        return components.url
    }
}
