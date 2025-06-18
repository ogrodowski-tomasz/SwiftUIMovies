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
            .appRouteDestinations()
        }
    }
}
