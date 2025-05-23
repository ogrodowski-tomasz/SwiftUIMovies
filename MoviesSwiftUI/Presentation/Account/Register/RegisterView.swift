import SwiftUI

struct RegisterView: View {

    // MARK: - PUBLIC PROPERTIES
    let onSubmit: (_ form: AuthForm) -> Void

    // MARK: - STATE PROPERTIES
    @State private var email: String = ""
    @State private var emailError: String? = nil

    @State private var password: String = ""
    @State private var passwordError: String? = nil

    @State private var name: String = ""
    @State private var nameError: String? = nil

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
                TextField("Name", text: $name)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            } header: {

            } footer: {
                if let nameError {
                    Text(nameError)
                        .foregroundStyle(.red)
                }
            }
            Section {
                Button("Register") {
                    register()
                }
            }
        }
    }

    private func register() {
        var formValidated = true
        if email.isEmpty {
            formValidated = false
            emailError = "Email field cannot be empty"
        } else if !email.contains("@") || !email.contains(".") {
            formValidated = false
            emailError = "Invalid email format"
        }

        if password.isEmpty {
            formValidated = false
            passwordError = "Password field cannot be empty"
        }

        if name.isEmpty {
            formValidated = false
            nameError = "Name field cannot be empty"
        }

        guard formValidated else {
            return
        }
        let form = AuthForm(email: email, password: password, name: name)
        onSubmit(form)
    }
}

#Preview {
    RegisterView { _ in }
}
