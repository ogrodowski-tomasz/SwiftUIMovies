import SwiftUI

struct SearchNavigationStack: View {
    @Environment(Router.self) private var router
    
    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.searchTabRoutes) {
            SearchScreen(searchNetworkManager: SearchNetworkManager(httpClient: HTTPClient()))
            .appRouteDestinations()
        }
    }
}

#Preview {
    SearchNavigationStack()
}
