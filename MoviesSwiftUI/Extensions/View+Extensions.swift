import SwiftUI

extension View {
    func appRouteDestinations() -> some View {
        self.navigationDestination(for: AppRoute.self) { route in
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
            case let .alternativeTitles(models):
                AlternativeTitlesListView(models: models)
            case let .fullCast(model):
                FullCastListView(cast: model)
            }
        }
    }
    
    func withProgressView(show: Binding<Bool>) -> some View {
        ZStack {
            self
            if show.wrappedValue {
                Color.black.opacity(0.2).ignoresSafeArea()
                ProgressView("Pobieranie danych...")
            }
        }
    }
    
    func inlineNavigationTitle(_ title: String) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

