import SwiftUI

// MARK: May be unneccesary because we use alerts instead of sheet
struct ErrorView: View {

    let errorWrapper: ErrorWrapper

    var body: some View {
        VStack {
            Text(errorWrapper.error.localizedDescription)
            Text(errorWrapper.guidance)
        }
    }
}

#Preview {
    ErrorView(errorWrapper: ErrorWrapper(error: NetworkError.badRequest, guidance: "Operation failed. Please try again later.") { })
}
