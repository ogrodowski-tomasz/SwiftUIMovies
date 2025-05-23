import Foundation

protocol CollectionStoreProtocol {
    func loadCollectionDetails() async throws -> CollectionDetailsApiModel
}


/// This object isn't observable because it doesn't hold state. Collections don't require that.
///
/// Just allows to fetch data and pass it to the view.
///
/// Worth considering if this object is even required or view should make API call by itself.
final class CollectionsStore: CollectionStoreProtocol {

    // MARK: - PUBLIC PROPERTIES

    // MARK: - PRIVATE PROPERTIES
    private let movieNetworkManager: MovieNetworkManagerProtocol
    private let collectionId: Int

    // MARK: - INITIALIZER

    init(collectionId: Int, movieNetworkManager: MovieNetworkManagerProtocol) {
        self.collectionId = collectionId
        self.movieNetworkManager = movieNetworkManager
    }

    // MARK: - PUBLIC METHODS

    func loadCollectionDetails() async throws -> CollectionDetailsApiModel {
        return try await movieNetworkManager.load(endpoint: .collectionDetails(collectionID: collectionId), decodeToType: CollectionDetailsApiModel.self)
    }

    // MARK: - PRIVATE METHODS

}
