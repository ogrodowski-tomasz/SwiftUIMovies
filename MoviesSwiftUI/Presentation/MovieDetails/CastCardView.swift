import SwiftUI

#warning("Create another initializer for MovieCast model")
struct CastCardView: View {
    let imagePath: String?
    let title: String
    let subtitle: String?

    var body: some View {
        HStack {
            AsyncImage(url: URL(imagePath: imagePath)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                default:
                    Rectangle()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 50, height: 75)
            .cornerRadius(5)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(subtitle ?? "Unknown")
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
        let member = castMember()
        return CastCardView(imagePath: member.profilePath, title: member.name, subtitle: member.character)
    }

    static func castMember() -> MovieCastApiModel {
        try! StaticJSONMapper.decode(file: MovieEndpoint.cast(movieId: 0).stubDataFilename!, type: MovieCastApiResponseModel.self).cast.first!
    }
}
