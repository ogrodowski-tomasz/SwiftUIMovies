import SwiftUI

struct MovieCardView: View {

    let movie: any MovieListRepresentable
    let review: ReviewModel?

    init(movie: any MovieListRepresentable, review: ReviewModel? = nil) {
        self.movie = movie
        self.review = review
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let moviePoster = movie.posterPath {
                    AsyncImage(url: URL(imagePath: moviePoster)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 75)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 75)
                    }
                } else {
                    Rectangle()
                        .frame(width: 50, height: 75)
                }

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(movie.releaseDate ?? "-")
                        .font(.footnote)
                        .fontWeight(.thin)
                    Text("⭐️ \(movie.voteAverage?.formatted() ?? "-")")
                }
            }
            if let reviewText = review?.review, let reviewRating = review?.rating {
                Divider()
                Text(reviewText)
                    .font(.caption)
                    .italic()
                Text("\(reviewRating)/10")
                    .bold()
            }
        }
    }
}
