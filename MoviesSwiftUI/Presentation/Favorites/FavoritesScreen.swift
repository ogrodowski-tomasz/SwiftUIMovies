import SwiftData
import SwiftUI

struct FavoritesScreen: View {

    // MARK: - ENVIRONMENT
    @Environment(\.modelContext) private var context
    @Environment(\.showError) private var showError
    @Environment(Router.self) private var router

    // MARK: - QUERY
    @Query private var favorites: [FavoriteMovie]
    @Query private var reviews: [ReviewModel]

    var body: some View {
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
        .inlineNavigationTitle("Favorites \(favorites.count > 0 ? "(\(favorites.count))" : "")")
        .toolbar {
            if !favorites.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", role: .destructive) {
                        deleteAllFavorites()
                    }
                }
            }
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

    private func save() {
        do {
            try context.save()
        } catch {
            showError(error, "Unable to delete favorites.", nil)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesScreen()
            .modelContainer(
                try! ModelContainer(
                    for: FavoriteMovie.self,
                    ReviewModel.self,
                    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                )
            )
            .environment(Router())
    }
}
