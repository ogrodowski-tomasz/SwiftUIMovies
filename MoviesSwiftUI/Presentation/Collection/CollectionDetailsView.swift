import SwiftUI

struct CollectionDetailsView: View {

    // MARK: - ENVIRONMENT
    @Environment(Router.self) var router

    // MARK: - PROPERTIES
    let collectionDetails: CollectionDetailsApiModel

    // MARK: - BODY
    var body: some View {
        ScrollView {
            VStack {
                backdropImage
                overview
                parts
            }
            .padding(.horizontal)
        }
        .inlineNavigationTitle(collectionDetails.name)
    }

    // MARK: - VIEW COMPONENTS
    var backdropImage: some View {
        AsyncImage(url: URL(imagePath: collectionDetails.backdropPath)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            case .failure(let error):
                Text(error.localizedDescription)
            @unknown default:
                Text("unknown case")
            }
        }
    }

    var overview: some View {
        Text(collectionDetails.overview)
            .font(.callout)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .cornerRadius(10)
    }

    var parts: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Parts of collection:")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(collectionDetails.parts) { part in
                    Button {
                        router.navigate(to: .movieDetails(id: part.id))
                    } label: {
                        CollectionPartCardView(part: part)
                    }
                }
            }
        }
    }

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 1)
    }
}



#Preview {
    NavigationStack {
        CollectionDetailsScreen(
            collectionStore: CollectionsStore(
                collectionId: 0,
                movieNetworkManager: MockMovieNetworkManager()
            )
        )
        .environment(Router())

    }
}
