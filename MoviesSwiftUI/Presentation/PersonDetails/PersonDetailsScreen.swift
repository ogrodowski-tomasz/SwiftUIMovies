import SwiftUI

struct PersonDetailsScreen: View {
    let personId: Int
    var body: some View {
        Text("Hello, World! \(personId)")
    }
}

#Preview {
    PersonDetailsScreen(personId: 192)
}
