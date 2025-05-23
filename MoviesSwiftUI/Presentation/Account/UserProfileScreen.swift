import SwiftUI

struct UserProfileScreen: View {
    @Environment(CurrentUserStore.self) private var currentUserStore
    var body: some View {
        Group {
            if let currentUser = currentUserStore.currentUser {
                UserProfileView(user: currentUser)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Profile")
    }
}

struct UserProfileView: View {
    let user: UserModel
    var body: some View {
        Form {
            Text(user.id)
            Text(user.email)
            Text(user.name)
        }
    }
}

#Preview {
    UserProfileScreen()
}
