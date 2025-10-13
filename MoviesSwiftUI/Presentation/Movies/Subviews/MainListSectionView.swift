import SwiftUI

struct MainListSectionView: View {

    // MARK: - ENVIRONMENT
    @Environment(Router.self) var router

    // MARK: - PROPERTIES
    let movies: [any MovieListRepresentable]
    let reviews: [ReviewModel]?
    let sectionTitle: String?
    let showMoreButton: Bool

    init(movies: [any MovieListRepresentable], reviews: [ReviewModel]? = nil, sectionTitle: String? = nil, showMoreButton: Bool) {
        self.movies = movies
        self.reviews = reviews
        self.sectionTitle = sectionTitle
        self.showMoreButton = showMoreButton
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
            if showMoreButton {
                Button("Show more") { }
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
        MainListSectionView(
            movies: try! StaticJSONMapper.decode(file: MovieEndpoint.topRated.stubDataFilename!, type: MovieApiResponseModel.self).results,
            sectionTitle: "Movie list", showMoreButton: true)
            .environment(Router())

    }
}
