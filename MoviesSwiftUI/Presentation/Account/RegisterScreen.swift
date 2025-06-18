import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AuthForm {
    let email: String
    let password: String
    let name: String?
}

struct RegisterScreen: View {

    // MARK: - ENVIRONMENT
    @Environment(\.showError) var showError
    @Environment(CurrentUserStore.self) var currentUserStore
    @Environment(Router.self) var router

    // MARK: - STATE
    @State private var userRegisteredSuccess = false


    var body: some View {
        RegisterView { form in
            Task {
                await register(with: form)
            }
        }
        .alert("Success!", isPresented: $userRegisteredSuccess, actions: {
            Button("Ok") {
                router.pop()
            }
        }, message: {
            Text("Registered successfully! Now you can log in.")
        })
        .inlineNavigationTitle("Register")
    }

    private func register(with form: AuthForm) async  {
        do {
            try await currentUserStore.register(with: form)
            userRegisteredSuccess = true
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            showError(error, "try again", nil)
        }
    }
}



#Preview {
    NavigationStack {
        RegisterScreen()
            .environment(CurrentUserStore(authManager: MockAuthenticationManager(), firestoreManager: MockFirestoreManager()))
            .environment(Router())

    }
}
