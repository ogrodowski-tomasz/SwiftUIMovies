import FirebaseAuth

// MARK: - PROTOCOL

extension User: AuthDataResultModelProtocol { }

protocol AuthenticationManagerProtocol {
    func currentUser() -> AuthDataResultModelProtocol?
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultModelProtocol
    func createUser(withEmail email: String, password: String, name: String?) async throws -> AuthDataResultModelProtocol
}

// MARK: - IMPLEMENTATION

final class AuthenticationManager: AuthenticationManagerProtocol {

    func currentUser() -> AuthDataResultModelProtocol? {
        return Auth.auth().currentUser
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultModelProtocol {
        try await Auth.auth().signIn(withEmail: email, password: password).user
    }

    func createUser(withEmail email: String, password: String, name: String?) async throws -> AuthDataResultModelProtocol {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        authResult.user.displayName = name
        return authResult.user
    }
}

// MARK: - MOCK

struct MockAuthResult: AuthDataResultModelProtocol {
    var uid: String
    var email: String?
    var displayName: String?
}

final class MockAuthenticationManager: AuthenticationManagerProtocol {
    func currentUser() ->  AuthDataResultModelProtocol? {
        return MockAuthResult(uid: "1234")
    }

    func signIn(withEmail email: String, password: String) async throws -> AuthDataResultModelProtocol {
        return MockAuthResult(uid: "1234", email: email, displayName: "Mockname")
    }
    
    func createUser(withEmail email: String, password: String, name: String?) async throws -> AuthDataResultModelProtocol {
        return MockAuthResult(uid: "123456789", email: email, displayName: name)
    }
}
