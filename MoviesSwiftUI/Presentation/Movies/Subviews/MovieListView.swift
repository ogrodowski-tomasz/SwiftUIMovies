import SwiftUI

struct MovieListView: View {

    // MARK: - ENVIRONMENT
    @Environment(Router.self) var router

    // MARK: - PROPERTIES
    let movies: [any MovieListRepresentable]
    let reviews: [ReviewModel]?
    let sectionTitle: String?

    init( movies: [any MovieListRepresentable], reviews: [ReviewModel]? = nil, sectionTitle: String? = nil) {
        self.movies = movies
        self.reviews = reviews
        self.sectionTitle = sectionTitle
    }

    // MARK: - BODY
    var body: some View {
        Section {
            ForEach(movies, id: \.id) { movie in
                Button {
                    router.navigate(to: .movieDetails(id: movie.id))
                } label: {
                    MovieCardView(movie: movie, review: reviewFor(movie))
                }
                .tint(.black)
            }
        } header: {
            if let sectionTitle {
                Text(sectionTitle)
            }
        }
    }

    func reviewFor(_ movie: any MovieListRepresentable) -> ReviewModel? {
        return reviews?.first(where: { $0.id == movie.id })
    }
}

// MARK: - PREVIEW
#Preview {
    List {
        MovieListView(
            movies: try! StaticJSONMapper.decode(file: MovieEndpoint.topRated.stubDataFilename!, type: MovieApiResponseModel.self).results,
            sectionTitle: "Movie list")
            .environment(Router())

    }
}
