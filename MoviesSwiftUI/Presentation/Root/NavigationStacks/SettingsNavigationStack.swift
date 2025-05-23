import SwiftUI

struct SettingsNavigationStack: View {

    @Environment(CurrentUserStore.self) private var currentUserStore
    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.settingsTabRoutes) {
            Group {
                if let _ = currentUserStore.currentUser {
                    UserProfileScreen()
                } else {
                    AuthenticationScreen()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case let .movieDetails(id):
                    MovieDetailsScreen(id: id)
                case let .collectionDetails(collectionId):
                    CollectionDetailsScreen(
                        collectionStore: CollectionsStore(
                            collectionId: collectionId,
                            movieNetworkManager: MovieNetworkManager(
                                httpClient: HTTPClient()
                            )
                        )
                    )
                case .review(movie: let movie):
                    AddReviewView(movie: movie)
                case .login:
                    LoginScreen()
                case .register:
                    RegisterScreen()
                case .userProfile:
                    UserProfileScreen()
                }
            }

        }
    }
}
