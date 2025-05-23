import FirebaseFirestore
import Foundation

protocol FirestoreManagerProtocol {
    func fetchUserModel(for uid: String) async -> UserModel?
    func setUserModel(_ userModel: UserModel) async throws
}

final class FirestoreManager: FirestoreManagerProtocol {

    // MARK: - PUBLIC PROPERTIES

    // MARK: - PRIVATE PROPERTIES

    // MARK: - INIT

    // MARK: - PUBLIC METHODS

    func fetchUserModel(for uid: String) async -> UserModel? {
        return try? await Firestore.firestore().collection(key: .users).document(uid).getDocument(as: UserModel.self)
    }

    func setUserModel(_ userModel: UserModel) async throws {
        try Firestore.firestore().collection(key: .users).document(userModel.id).setData(from: userModel)
    }

    // MARK: - PRIVATE METHODS

}

final class MockFirestoreManager: FirestoreManagerProtocol {
    func fetchUserModel(for uid: String) async -> UserModel? {
        return UserModel(id: "1234567", email: "mock@email.com", name: "Mock Name")
    }
    
    func setUserModel(_ userModel: UserModel) async throws {
        
    }
    

}
