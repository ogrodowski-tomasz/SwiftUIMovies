import FirebaseCore
import SwiftData
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct MoviesSwiftUIApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var currentUserStore: CurrentUserStore
    @State private var movieStore: MovieStore
    @State private var router: Router

    @State private var showError: Bool = false
    @State private var errorWrapper: ErrorWrapper?

    init() {
        let httpClient = HTTPClient()
        let movieNetworkManager = MovieNetworkManager(httpClient: httpClient)
        movieStore = MovieStore(movieNetworkManager: movieNetworkManager)
        router = Router()
        let authManager = AuthenticationManager()
        let firestoreManager = FirestoreManager()
        currentUserStore = CurrentUserStore(authManager: authManager, firestoreManager: firestoreManager)
    }

    var modelContainer: ModelContainer {
        do {
            let schema = Schema([
                FavoriteMovie.self,
                ReviewModel.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(movieStore)
                .environment(router)
                .environment(currentUserStore)
                .environment(\.showError, ShowErrorAction(action: showError))
                .alert("Error occured!", isPresented: $showError, actions: {
                    if let retryAction = errorWrapper?.retryAction {
                        Button("Retry") {
                            retryAction()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }, message: {
                    Text(errorWrapper?.error.localizedDescription ?? "Unknown error")
                })
                .task {
                    await currentUserStore.getAuthenticatedUser()
                }
        }
        .modelContainer(modelContainer)
    }

    private func showError(error: Error, guidance: String, retryAction: (() -> Void)?) {
        errorWrapper = ErrorWrapper(error: error, guidance: guidance, retryAction: retryAction)
        showError = true
    }
}
