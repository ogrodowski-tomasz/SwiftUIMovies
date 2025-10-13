import XCTest
@testable import MoviesSwiftUI

final class MoviesSwiftUITests: XCTestCase {

    func test_mergedById() {
        let stanLeeId: Int = 7624
        let stubCast: [MovieCastApiModel] = [
            .init(adult: false, id: stanLeeId, name: "Stan Lee", profilePath: "/kKeyWoFtTqOPsbmwylNHmuB3En9.jpg", character: "Driver", knownForDepartment: "Writing", popularity: 0.035, job: "Characters"),
            .init(adult: false, id: stanLeeId, name: "Stan Lee", profilePath: "/kKeyWoFtTqOPsbmwylNHmuB3En9.jpg", character: "Driver", knownForDepartment: "Writing", popularity: 0.035, job: "Executive Producer"),
            .init(adult: false, id: stanLeeId, name: "Stan Lee", profilePath: "/kKeyWoFtTqOPsbmwylNHmuB3En9.jpg", character: "Driver", knownForDepartment: "Writing", popularity: 0.035, job: "In Memory Of"),
            .init(adult: false, id: 19272, name: "Joe Russo", profilePath: "/o0OXjFzL10jCy89iAs7UzzSbyoK.jpg", character: nil, knownForDepartment: "Production", popularity: 0.013, job: "Director"),
            .init(adult: false, id: 19271, name: "Anthony Russo", profilePath: "/xbINBnWn28YygYWUJ1aSAw0xPRv.jpg", character: nil, knownForDepartment: "Directing", popularity: 0.016, job: "Director")
        ]
        
        let result = stubCast.mergedById()

        XCTAssertEqual(result.count, 3)
        let filtered = result.filter { $0.id == stanLeeId }
        XCTAssertEqual(filtered.count, 1, "There should be only one Stan Lee in array")
        let stanLee = result.first(where: { $0.id == stanLeeId })
        XCTAssertEqual(stanLee?.job, "Characters / Executive Producer / In Memory Of")
    }
}
