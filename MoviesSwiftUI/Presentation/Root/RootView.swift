import SwiftUI

struct RootView: View {

    // MARK: - ENVIRONMENT
    @Environment(Router.self) var router

    // MARK: - STATE MANAGEMENT
    @State private var selection: AppTab? = .movies

    // MARK: - BODY
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases) { screen in
                screen.destination
                    .tag(screen as AppTab)
                    .tabItem {
                        screen.label
                    }
            }
            // Letting Router know that selected tab changed and navigation should be applied to different stack
            .onChange(of: selection) { oldValue, newValue in
                guard let newValue else { return }
                router.setCurrentTab(newValue)
            }
            // Letting TabView know that Router changed current tab by itself and UI should reflect that
            .onChange(of: router.currentTap) { oldValue, newValue in
                guard selection != newValue else { return }
                selection = newValue
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RootView()
        .environment(Router())
}
