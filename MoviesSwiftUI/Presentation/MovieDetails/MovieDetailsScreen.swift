import SwiftData
import SwiftUI

struct MovieDetailsScreen: View {
    
    // MARK: - ENVIRONMENT
    @Environment(\.showError) private var showError
    @Environment(\.modelContext) private var context
    
    @Environment(Router.self) private var router
    @Environment(\.httpClient) var httpClient
    
    // MARK: - STATE
    @State private var movieDetails: MovieDetailsApiModel? = nil
    @State private var movieCast: MovieCastApiResponseModel? = nil
    @State private var movieAlternativeTitles: MovieAlternativeTitlesResponseModel? = nil
    
    // MARK: - QUERY
    @Query private var favorites: [FavoriteMovie]
    @Query private var reviews: [ReviewModel]
    
    // MARK: - PROPERTIES
    let id: Int
    
    // MARK: - INITIALIZER
    init(id: Int) {
        self.id = id
        _reviews = Query(filter: #Predicate<ReviewModel> { $0.id == id })
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let movieDetails, let movieCast, let movieAlternativeTitles {
                MovieDetailsView(
                    movie: movieDetails,
                    cast: movieCast,
                    alternativeTitles: movieAlternativeTitles.titles
                )
            } else {
                ProgressView()
            }
        }
        .toolbar {
            if let movieDetails {
                ToolbarItem(placement: .topBarTrailing) {
                    let isFavorite = isFavorite(movieDetails.id)
                    Button("Add to favorites", systemImage: isFavorite ? "heart.fill" : "heart") {
                        toggleFavorite(movieDetails.id)
                    }
                    .tint(.red)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    guard let movieDetails = movieDetails else { return }
                    router.navigate(to: .review(movie: movieDetails))
                } label: {
                    if let review = reviews.first, let rating = review.rating {
                        HStack(spacing: 10) {
                            Text("You've rated this movie:")
                                .opacity(0.75)
                            Text("\(rating)/10")
                                .bold()
                            
                            
                            Image(systemName: "pencil")
                                .foregroundStyle(.blue)
                        }
                        .foregroundStyle(.black)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("Leave a review!")
                            .foregroundStyle(.blue)
                            .padding()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .task {
            if movieDetails == nil, movieCast == nil, movieAlternativeTitles == nil {
                await loadDetails()
            }
        }
    }
    
    // MARK: - VIEW COMPONENTS
    
    // MARK: - PRIVATE METHODS
    
    private func loadDetails() async {
        do {
            let detailsResource = try Resource(endpoint: .movieDetails(id: id), modelType: MovieDetailsApiModel.self)
            let castResource = try Resource(endpoint: .cast(movieId: id), modelType: MovieCastApiResponseModel.self)
            let alternativeTitlesResource = try Resource(endpoint: .alternativeTitles(movieId: id), modelType: MovieAlternativeTitlesResponseModel.self)

            async let fetchedDetails = httpClient.load(detailsResource)
            async let fetchedCast = httpClient.load(castResource)
            async let fetchedAlternativeTitles = httpClient.load(alternativeTitlesResource, keyDecodingStrategy: nil)
            movieDetails = try await fetchedDetails
            movieCast = try await fetchedCast
            movieAlternativeTitles = try await fetchedAlternativeTitles
        } catch {
            showError(error, "Try again later.") {
                Task {
                    await loadDetails()
                }
            }
        }
    }
    
    private func isFavorite(_ movieId: Int) -> Bool {
        guard !favorites.isEmpty else { return false }
        return favorites.contains(where: { $0.id == movieId })
    }
    
    private func toggleFavorite(_ movieId: Int) {
        guard let movieDetails else { return }
        if let favorite = favorites.first(where: { $0.id == movieId }) {
            context.delete(favorite)
        } else {
            let newFavorite = FavoriteMovie.init(id: movieId, title: movieDetails.title, posterPath: movieDetails.posterPath, releaseDate: movieDetails.releaseDate, voteAverage: movieDetails.voteAverage)
            context.insert(newFavorite)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            showError(error, "Could not save data.") {
                saveContext()
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        MovieDetailsScreen(id: 278)
            .environment(Router()) // Needed in deeper subview
            .environment(\.httpClient, MockHTTPClient())
            .modelContainer(try! ModelContainer(for: FavoriteMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
    }
}
