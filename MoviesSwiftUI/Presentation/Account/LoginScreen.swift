import SwiftUI

struct LoginScreen: View {

    @Environment(\.showError) private var showError
    @Environment(CurrentUserStore.self) private var currentUserStore
    @Environment(Router.self) private var router

    var body: some View {
        LoginView { loginForm in
            Task {
                await login(with: loginForm)
            }
        }
        .inlineNavigationTitle("Login")
    }

    private func login(with loginForm: AuthForm) async  {
        do {
            try await currentUserStore.login(with: loginForm)
            router.navigate(to: .userProfile, fromRoot: true)
        } catch {
            showError(error, "Try logging later", nil)
        }
    }
}

struct LoginView: View {

    // MARK: - PUBLIC PROPERTIES
    let onSubmit: (AuthForm) -> Void

    // MARK: - STATE
    @State private var email: String = ""
    @State private var emailError: String? = nil
    @State private var password: String = ""
    @State private var passwordError: String? = nil

    var body: some View {
        Form {
            Section {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            } header: {

            } footer: {
                if let emailError {
                    Text(emailError)
                        .foregroundStyle(.red)
                }
            }

            Section {
                SecureField("Password", text: $password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            } header: {

            } footer: {
                if let passwordError {
                    Text(passwordError)
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button("Login") {
                    login()
                }
            }
        }
    }

    private func login() {
        var formValidated = true

        if !email.contains("@") || !email.contains(".") {
            formValidated = false
            emailError = "Invalid format"
        }

        if email.isEmpty {
            formValidated = false
            emailError = "Email is required"
        }


        if password.isEmpty {
            formValidated = false
            passwordError = "Password is required"
        }

        guard formValidated else {
            return
        }
        let form = AuthForm(email: email, password: password, name: nil)
        onSubmit(form)
    }
}

#Preview {
    NavigationStack {
        LoginScreen()
            .environment(CurrentUserStore(authManager: MockAuthenticationManager(), firestoreManager: MockFirestoreManager()))
            .environment(Router())
    }
}
