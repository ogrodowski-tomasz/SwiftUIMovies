import SwiftData
import SwiftUI

struct AddReviewView: View {

    // MARK: - ENVIRONMENT
    @Environment(\.modelContext) private var modelContext

    // MARK: - STATE
    @State private var reviewModel: ReviewModel? = nil
    @State private var ratingSelected: Int = 0
    @State private var reviewText: String = ""

    // MARK: - PROPERTIES
    let movie: any MovieListRepresentable

    // MARK: - INIT
    init(movie: any MovieListRepresentable) {
        self.movie = movie
    }

    // MARK: - PRIVATE PROPERTIES
    private var submitDisabled: Bool {
        ratingSelected == 0 || reviewText.isEmpty
    }

    // MARK: - BODY
    var body: some View {
        List {
            Section("Add review") {
                Picker(selection:  $ratingSelected) {
                    ForEach(0...10, id: \.self) { num in
                        Text("\(num)")
                    }
                } label: {
                    Text("Rating: ")
                }
                TextField("Write something to remember...", text: $reviewText, axis: .vertical)
            }
            Button("Submit") {
                saveReview()
            }
            .disabled(submitDisabled)
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchReviewModel()
        }
    }

    private func fetchReviewModel() {
        let movieId: Int = movie.id
        do {
            let descriptor = FetchDescriptor<ReviewModel>(predicate: #Predicate { $0.id == movieId })
            if let currentReview = try modelContext.fetch(descriptor).first {
                reviewModel = currentReview
                reviewText = reviewModel?.review ?? ""
                ratingSelected = reviewModel?.rating ?? 0
            }
        } catch {
            print("DEBUG: ERROR: \(error)")
        }
    }

    private func saveReview() {
        if let alreadyExistingReview = reviewModel {
            alreadyExistingReview.rating = ratingSelected
            alreadyExistingReview.review = reviewText
        } else {
            let newReview = ReviewModel(id: movie.id, review: reviewText, rating: ratingSelected)
            modelContext.insert(newReview)
            reviewModel = newReview
        }
        save()
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("DEBUG: Error saving context: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        AddReviewView(
            movie: try! StaticJSONMapper.decode(
                file: MovieEndpoint.topRated.stubDataFilename!,
                type: MovieApiResponseModel.self
            ).results.first!
        )
    }
}
