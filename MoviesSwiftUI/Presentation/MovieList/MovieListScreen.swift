import SwiftUI

struct MovieListScreen: View {
    
    enum MovieListType {
        case topRated
        case popular
        case nowPlaying
    }
    
    @Environment(\.httpClient) private var httpClient
    @State private var movies: [MovieApiModel]
    @State private var page: Int = 1
    
    private let listType: MovieListType
    
    init(initial: [MovieApiModel], movieListType: MovieListType) {
        _movies = .init(initialValue: initial)
        self.listType = movieListType
    }
    
    var body: some View {
        List {
            ForEach(movies) { movie in
                MovieCardView(movie: movie)
            }
            ProgressView()
                .onAppear {
                    page += 1
                }
        }
        .task(id: page) {
            guard page > 1 else { return }
            await fetchNextPage()
        }
    }
    
    private func fetchNextPage() async {
        do {
            let endpoint: MovieEndpoint
            
            switch listType {
            case .topRated:
                endpoint = .topRated(page: page)
            case .popular:
                endpoint = .popular(page: page)
            case .nowPlaying:
                endpoint = .nowPlaying(page: page)
            }
            
            let result = try await httpClient.load(endpoint, modelType: MovieApiResponseModel.self, keyDecodingStrategy: .convertFromSnakeCase).results
            let updated = movies + result
            movies = updated
        } catch {
            print("DEBUG: ERROR fetching next page: \(error)")
        }
    }
}

#Preview {
    MovieListScreen(initial: [], movieListType: .nowPlaying)
}
