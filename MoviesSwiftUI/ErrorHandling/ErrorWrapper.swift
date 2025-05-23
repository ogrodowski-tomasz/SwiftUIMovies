import Foundation
import SwiftUI

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
    let retryAction: (() -> Void)?

    init(error: Error, guidance: String, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.guidance = guidance
        self.retryAction = retryAction
    }
}

struct ShowErrorAction {
    typealias Action = (_ error: Error, _ guidance: String, _ retryAction: (() -> Void)?) -> ()
    let action: Action

    func callAsFunction(_ error: Error, _ guidance: String, _ retryAction: (() -> Void)?) {
        action(error, guidance, retryAction)
    }
}

struct ShowErrorEnvironmentKey: EnvironmentKey {
    static let defaultValue: ShowErrorAction = .init { _, _, _ in }
}

extension EnvironmentValues {
    var showError: ShowErrorAction {
        get {
            self[ShowErrorEnvironmentKey.self]
        } set {
            self[ShowErrorEnvironmentKey.self] = newValue
        }
    }
}
