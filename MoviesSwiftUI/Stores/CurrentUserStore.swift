import FirebaseAuth
import FirebaseFirestore
import Foundation

// MARK: - IMPLEMENTATION

@Observable
final class CurrentUserStore {    

    // MARK: - PUBLIC PROPERTIES

    var currentUser: UserModel? = nil

    // MARK: - PRIVATE PROPERTIES

    private let firestoreManager: FirestoreManagerProtocol
    private let authManager: AuthenticationManagerProtocol

    // MARK: - INIT

    init(authManager: AuthenticationManagerProtocol, firestoreManager: FirestoreManagerProtocol) {
        self.authManager = authManager
        self.firestoreManager = firestoreManager
    }

    // MARK: - PUBLIC METHODS

    func getAuthenticatedUser() async {
        guard let authUser = authManager.currentUser() else {
            return
        }
        await setUserModel(for: authUser.uid)
    }

    func register(with form: AuthForm) async throws {
        let authDataResult = try await authManager.createUser(withEmail: form.email, password: form.password, name: form.name)
        let user = UserModel(auth: authDataResult)
        try await firestoreManager.setUserModel(user)
    }

    func login(with form: AuthForm) async throws {
        let authDataResult = try await authManager.signIn(withEmail: form.email, password: form.password)
        let userId = authDataResult.uid
        await setUserModel(for: userId)
    }

    // MARK: - PRIVATE METHODS

    private func setUserModel(for uid: String) async {
        currentUser = await firestoreManager.fetchUserModel(for: uid)
    }

}
