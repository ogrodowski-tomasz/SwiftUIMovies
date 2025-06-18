import SwiftUI

struct FavoritesNavigationStack: View {

    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.favoritesTabRoutes) {
            Group {
                FavoritesScreen()
            }
            .appRouteDestinations()
        }
    }
}
