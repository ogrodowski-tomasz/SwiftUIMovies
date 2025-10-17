import Foundation

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError(Error)
    case invalidResponse
    case invalidURL
    case httpError(Int)
    case generic(path: String, errorMessage: String)
}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Unable to perform request", comment: "badRequestError")
        case .serverError(let errorMessage):
            return NSLocalizedString(errorMessage, comment: "serverError")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully.", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "invalidResponse")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case .httpError(_):
            return NSLocalizedString("Bad request", comment: "badRequest")
        case .generic(let path, let message):
            return NSLocalizedString("Missing stubDataFilename", comment: "Missing stubDataFilename for \(path)")
        }
    }

}
