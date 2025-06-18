import SwiftUI

struct MoviesNavigationStack: View {

    @Environment(Router.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.movieTabRoutes) {
            Group {
                MovieListScreen()
            }
            .appRouteDestinations()
        }
    }
}
