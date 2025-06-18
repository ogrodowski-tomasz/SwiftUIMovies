import SwiftUI

struct AuthenticationScreen: View {

    @Environment(Router.self) var router

    var body: some View {
        Group {
            AuthenticationView()
        }
        .inlineNavigationTitle("Authentication")
    }
}

struct AuthenticationView: View {

    @Environment(Router.self) private var router

    var body: some View {
        List {
            Section("Login") {
                Button {
                    router.navigate(to: .login)
                } label: {
                    HStack {
                        Text("Sign In")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.primary)
            }
            Section("Register") {
                Button {
                    router.navigate(to: .register)
                } label: {
                    HStack {
                        Text("Sign Up")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
                .tint(.primary)
            }
        }
    }
}

private struct AuthenticationScreenContainer: View {

    @State private var router = Router()
    @State private var userStore = CurrentUserStore(authManager: MockAuthenticationManager(), firestoreManager: MockFirestoreManager())

    var body: some View {
        SettingsNavigationStack()
            .environment(router)
            .environment(userStore)
            .task {
                await userStore.getAuthenticatedUser()
            }
    }
}

#Preview {
    AuthenticationScreenContainer()
}
