import Foundation
import SwiftData

@Model
final class ReviewModel {
    @Attribute(.unique) var id: Int
    var review: String? = nil
    var rating: Int? = nil

    init(id: Int, review: String? = nil, rating: Int? = nil) {
        self.id = id
        self.review = review
        self.rating = rating
    }
}
