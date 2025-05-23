import SwiftUI

struct CollectionPartCardView: View {
    let part: CollectionPartsApiModel

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            AsyncImage(url: URL(imagePath: part.backdropPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                case .failure(let error):
                    Text(error.localizedDescription)
                        .frame(maxWidth: .infinity)
                @unknown default:
                    Text("Unknown")

                }
            }
            VStack(alignment: .center, spacing: 5) {
                Text(part.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(part.releaseDate)
                    .font(.caption)
                    .fontWeight(.thin)
            }
            .padding(.vertical)
        }
        .background(.gray.opacity(0.5))
        .cornerRadius(10)
        .foregroundStyle(.black)
    }
}
