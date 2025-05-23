import SwiftUI

struct CastCardView: View {
    let castMember: MovieCastApiModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(imagePath: castMember.profilePath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 50, height: 75)
                        .cornerRadius(5)
                case .failure(let error):
                    Text("error \(error.localizedDescription)")
                @unknown default:
                    Text("unknown default")
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(castMember.name)
                    .font(.headline)
                Text(castMember.character ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.thin)
            }
        }
        .padding(.trailing)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
    }
}

struct CastCardView_Previews: PreviewProvider {

    static var previews: some View {
        CastCardView(castMember: castMember())
    }

    static func castMember() -> MovieCastApiModel {
        try! StaticJSONMapper.decode(file: MovieEndpoint.cast(movieId: 0).stubDataFilename!, type: MovieCastApiResponseModel.self).cast.first!
    }
}
