import SwiftData
import SwiftUI

struct FavoritesScreen: View {

    // MARK: - ENVIRONMENT
    @Environment(\.modelContext) private var context
    @Environment(\.showError) private var showError
    @Environment(Router.self) private var router

    // MARK: - QUERY
    @Query private var favorites: [FavoriteMovie]
    @Query private var watchlist: [WatchlistMovieModel]
    @Query private var reviews: [ReviewModel]
    
    // MARK: - STATE
    @State private var selectedTab: FavoritesTab = .favorites
    
    enum FavoritesTab: String, CaseIterable {
        case favorites = "Favorites"
        case watchlist = "Watchlist"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Segmented picker
            Picker("Favorites Tab", selection: $selectedTab) {
                ForEach(FavoritesTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content based on selected tab
            Group {
                if selectedTab == .favorites {
                    favoritesContent
                } else {
                    watchlistContent
                }
            }
        }
        .inlineNavigationTitle("My Lists")
        .toolbar {
            if hasItemsToClear {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", role: .destructive) {
                        clearCurrentTab()
                    }
                }
            }
        }
    }
    
    private var favoritesContent: some View {
        Group {
            if favorites.isEmpty && reviews.isEmpty {
                ContentUnavailableView {
                    VStack {
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundStyle(.red)
                        Text("No favorites yet.")
                            .font(.title3)
                        Text("Browse through movies to add them to your favorites.")
                            .font(.callout)
                            .foregroundStyle(.secondary)

                        Button {
                            router.setCurrentTab(.movies, toRoot: true)
                        } label: {
                            Text("Let's go!")
                        }
                        .foregroundStyle(.white)
                        .padding(10)
                        .padding(.horizontal)
                        .background(.blue)
                        .cornerRadius(10)
                    }
                }
            } else {
                List {
                    MainListSectionView(movies: favorites, reviews: reviews, showMoreButton: false)
                }
            }
        }
    }
    
    private var watchlistContent: some View {
        Group {
            if watchlist.isEmpty {
                ContentUnavailableView {
                    VStack {
                        Image(systemName: "bookmark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                        Text("No watchlist yet.")
                            .font(.title3)
                        Text("Add movies to your watchlist to keep track of what you want to watch.")
                            .font(.callout)
                            .foregroundStyle(.secondary)

                        Button {
                            router.setCurrentTab(.movies, toRoot: true)
                        } label: {
                            Text("Browse Movies")
                        }
                        .foregroundStyle(.white)
                        .padding(10)
                        .padding(.horizontal)
                        .background(.blue)
                        .cornerRadius(10)
                    }
                }
            } else {
                List {
                    MainListSectionView(movies: watchlist, reviews: [], showMoreButton: false)
                }
            }
        }
    }
    
    private var hasItemsToClear: Bool {
        switch selectedTab {
        case .favorites:
            return !favorites.isEmpty || !reviews.isEmpty
        case .watchlist:
            return !watchlist.isEmpty
        }
    }
    private func clearCurrentTab() {
        switch selectedTab {
        case .favorites:
            deleteAllFavorites()
        case .watchlist:
            deleteAllWatchlist()
        }
    }
    
    private func deleteAllFavorites() {
        for favorite in favorites {
            context.delete(favorite)
        }
        for review in reviews {
            context.delete(review)
        }
        save()
    }
    
    private func deleteAllWatchlist() {
        for movie in watchlist {
            context.delete(movie)
        }
        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            showError(error, "Unable to delete items.", nil)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesScreen()
            .modelContainer(
                try! ModelContainer(
                    for: FavoriteMovie.self,
                    WatchlistMovieModel.self,
                    ReviewModel.self,
                    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                )
            )
            .environment(Router())
    }
}
