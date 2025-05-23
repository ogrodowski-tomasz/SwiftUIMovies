import FirebaseFirestore

extension Firestore {

    enum CollectionKeys: String {
        case users
    }

    func collection(key: CollectionKeys) -> CollectionReference {
        return self.collection(key.rawValue)
    }
}
