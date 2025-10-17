import Foundation

protocol AppEndpoint {
    var url: URL? { get }
    var stubDataFilename: String? { get }
    var method: String { get }
    var queryItems: [URLQueryItem]? { get }
}

enum MovieEndpoint {
    case topRated(page: Int)
    case popular(page: Int)
    case nowPlaying(page: Int)
    case movieDetails(id: Int)
    case cast(movieId: Int)
    case collectionDetails(collectionID: Int)
    case alternativeTitles(movieId: Int)
    case personDetails(personId: Int)
}

extension MovieEndpoint: AppEndpoint {

    var scheme: String {
        "https"
    }

    var host: String {
        "api.themoviedb.org"
    }

    var baseURL: String {
        "https://api.themoviedb.org/3/"
    }
    
    var method: String {
        switch self {
        default: return "GET"
        }
    }

    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .popular:
            return "/3/movie/popular"
        case .nowPlaying:
            return "/3/movie/now_playing"
        case let .movieDetails(id):
            return "/3/movie/\(id)"
        case let .cast(movieId):
            return "/3/movie/\(movieId)/credits"
        case let .collectionDetails(collectionID):
            return "/3/collection/\(collectionID)"
        case let .alternativeTitles(movieId):
            return "/3/movie/\(movieId)/alternative_titles"
        case let .personDetails(personId):
            return "/3/person/\(personId)"
        }
    }

    var stubDataFilename: String? {
        switch self {
        case .topRated:
            return "MovieTopRatedStubData"
        case .popular:
            return "MoviePopularStubData"
        case .nowPlaying:
            return "MovieNowPlayingStubData"
        case .movieDetails:
            return "MovieDetailsStubData"
        case .cast:
            return "CastStubData"
        case .collectionDetails:
            return "CollectionDetailsStubData"
        case .alternativeTitles:
            return "MovieDetailsAlternativeTitles"
        case .personDetails:
            return "PersonDetailsStubData"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .topRated(page), let .popular(page), let .nowPlaying(page):
            return [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
        case .cast, .collectionDetails, .alternativeTitles, .personDetails, .movieDetails:
            return nil
        }
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        // TODO: Add queryItems handling for page or lang
        // language=en-US&page=1
        if let queryItems {
            components.queryItems = queryItems
        }
        return components.url
    }
}
