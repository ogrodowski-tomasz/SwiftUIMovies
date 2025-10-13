import Foundation
import SwiftUI

// MARK: - APP TAB

/// App tab views
///
/// `movies` tab and `settings` tab
enum AppTab: Hashable, Identifiable, CaseIterable {
    case movies
    case favorites
    case search
    case settings

    var id: AppTab { self }

    @ViewBuilder
    var label: some View {
        switch self {
        case .movies:
            Label("Movies", systemImage: "camera")
        case .favorites:
            Label("Favorites", systemImage: "heart.fill")
        case .search:
            Label("Search", systemImage: "magnifyingglass")
        case .settings:
            Label("Settings", systemImage: "gear")
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .movies:
            MoviesNavigationStack()
        case .favorites:
            FavoritesNavigationStack()
        case .search:
            SearchNavigationStack()
        case .settings:
            SettingsNavigationStack()
        }
    }
}

// MARK: - APP ROUTES

/// Navigation actions possible within app
enum AppRoute: Hashable {
    case movieDetails(id: Int)
    case collectionDetails(collectionId: Int)
    case review(movie: any MovieListRepresentable)
    case login
    case register
    case userProfile
    case alternativeTitles(models: [MovieAlternativeTitlesModel])
    case fullCast(model: MovieCastApiResponseModel)
    case moreMovies(initial: [MovieApiModel], listType: MovieListScreen.MovieListType)
    

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.movieDetails(id1), .movieDetails(id2)):
            return id1 == id2
        case let (.collectionDetails(id1), .collectionDetails(id2)):
            return id1 == id2
        case let (.review(movie1), .review(movie2)):
            return movie1.id == movie2.id
        case (.login, .login):
            return true
        case (.register, .register):
            return true
        case (.userProfile, .userProfile):
            return true
        case let (.fullCast(lhsCast), .fullCast(rhsCast)):
            return lhsCast.id == rhsCast.id
        case let (.moreMovies(lhsInitial, lhsType), .moreMovies(rhsInitial, rhsType)):
            return lhsInitial == rhsInitial && lhsType == rhsType
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .movieDetails(id):
            hasher.combine(0)
            hasher.combine(id)
        case let .collectionDetails(collectionId):
            hasher.combine(1)
            hasher.combine(collectionId)
        case let .review(movie):
            hasher.combine(2)
            hasher.combine(movie.id)
        case .login:
            hasher.combine(3)
        case .register:
            hasher.combine(4)
        case .userProfile:
            hasher.combine(5)
        case let .alternativeTitles(models):
            hasher.combine(6)
            hasher.combine(models)
        case let .fullCast(model):
            hasher.combine(7)
            hasher.combine(model.id)
        case let .moreMovies(initial, _):
            hasher.combine(8)
            hasher.combine(initial)
        }
    }
}

/// App Router
///
/// Relays on: `AppTab` enum.
///
/// Holds current navigaiton stack for all tabs and allows to push and pop views to appropriate stack.
/// Each tab has its own navigation stack.
///
/// `Worth to consider!`
///
/// Should every stack relay on the same AppRoute?
@Observable
class Router {
    var currentTap: AppTab = .movies

    var movieTabRoutes: [AppRoute] = []
    var favoritesTabRoutes: [AppRoute] = []
    var settingsTabRoutes: [AppRoute] = []
    var searchTabRoutes: [AppRoute] = []


    func setCurrentTab(_ tab: AppTab, toRoot: Bool = false) {
        if toRoot {
            popToRoot(on: tab)
        }
        self.currentTap = tab
    }

    func navigate(to path: AppRoute, fromRoot: Bool = false) {
        if fromRoot {
            popToRoot()
        }
        switch currentTap {
        case .movies:
            movieTabRoutes.append(path)
        case .favorites:
            favoritesTabRoutes.append(path)
        case .settings:
            settingsTabRoutes.append(path)
        case .search:
            searchTabRoutes.append(path)
        }
    }

    func pop() {
        switch currentTap {
        case .movies:
            guard !movieTabRoutes.isEmpty else { return }
            movieTabRoutes.removeLast()
        case .favorites:
            guard !favoritesTabRoutes.isEmpty else { return }
            favoritesTabRoutes.removeLast()
        case .settings:
            guard !settingsTabRoutes.isEmpty else { return }
            settingsTabRoutes.removeLast()
        case .search:
            guard !searchTabRoutes.isEmpty else { return }
            searchTabRoutes.removeLast()
        }
    }

    func popToRoot(on appTab: AppTab? = nil) {
        let tab = appTab ?? currentTap
        switch tab {
        case .movies:
            movieTabRoutes.removeAll()
        case .favorites:
            favoritesTabRoutes.removeAll()
        case .settings:
            settingsTabRoutes.removeAll()
        case .search:
            searchTabRoutes.removeAll()
        }
    }
}



