import SwiftUI

struct CollectionDetailsScreen: View {

    @Environment(\.showError) private var showError
    @State private var collectionStore: CollectionStoreProtocol

    init(collectionStore: CollectionStoreProtocol) {
        self.collectionStore = collectionStore
    }

    @State private var collectionDetails: CollectionDetailsApiModel? = nil

    var body: some View {
        Group {
            if let collectionDetails {
                CollectionDetailsView(collectionDetails: collectionDetails)
            } else {
                ProgressView()
            }
        }
        .task {
            await loadCollectionDetails()
        }
    }

    private func loadCollectionDetails() async {
        do {
            collectionDetails = try await collectionStore.loadCollectionDetails()
        } catch {
            showError(error, "Try again later", nil)
        }
    }
}

#Preview {
    NavigationStack {
        CollectionDetailsScreen(
            collectionStore: CollectionsStore(
                collectionId: -1,
                movieNetworkManager: MockMovieNetworkManager()
            )
        )
        .environment(MovieStore(movieNetworkManager: MockMovieNetworkManager()))
        .environment(Router())
    }
}

