import Foundation

extension String {
    var flagEmoji: String {
        let base: UInt32 = 127397
        var emoji = ""
        for scalar in self.uppercased().unicodeScalars {
            guard let unicode = UnicodeScalar(base + scalar.value) else { continue }
            emoji.unicodeScalars.append(unicode)
        }
        return emoji
    }
}

