# SwiftUIMovies

SwiftUIMovies is a modern iOS application built with SwiftUI, designed to provide users with a rich and interactive experience for discovering, browsing, and managing movies. The app leverages Firebase for authentication and data storage, and integrates with external movie APIs to fetch up-to-date movie information.

---

## Supported iOS Version

- **Minimum iOS Version:** iOS 18.1  
  (SwiftUI and SwiftData features used in the project require iOS 18.1 or later.)

---

## Dependencies

### Core Dependencies

- **SwiftUI**: For building declarative, modern user interfaces.
- **SwiftData**: For local data persistence and model management.
- **Firebase**:  
  - **FirebaseCore**: Core Firebase services initialization.
  - **Authentication**: User authentication and management.
  - **Firestore**: Cloud Firestore for storing user data, favorites, and reviews.

### Networking

- **Custom HTTPClient**: Handles API requests to fetch movie data.
- **MovieNetworkManager & GenreNetworkManager**: Abstractions for interacting with movie and genre endpoints.

### Other

- **Custom Error Handling**: Centralized error handling and user-friendly error presentation.
- **Environment Stores**: State management using custom stores for movies, users, and navigation.

---

## Application Overview

SwiftUIMovies is a movie discovery and management app that allows users to:

- Browse popular, top-rated, and now-playing movies.
- View detailed information about each movie, including cast, genres, and collections.
- Search for movies and explore collections.
- Mark movies as favorites and manage a personal favorites list.
- Register, log in, and manage user profiles.
- Add and view reviews for movies.
- Seamlessly navigate between different sections using a custom navigation stack.

---

## Features

### 1. **Authentication**
- User registration and login via Firebase Authentication.
- Secure user session management.
- User profile management.

### 2. **Movie Discovery**
- Browse movies by categories: Popular, Top Rated, Now Playing.
- Search for movies by title or genre.
- View detailed movie information, including:
  - Overview, release date, genres, runtime, and rating.
  - Cast and crew details.
  - Belonging collections and related movies.

### 3. **Favorites**
- Add or remove movies from personal favorites.
- View and manage a list of favorite movies.

### 4. **Reviews**
- Add reviews for movies.
- View reviews from other users.

### 5. **Collections**
- Explore movie collections and their parts.
- View details for each collection and its movies.

### 6. **Error Handling**
- User-friendly error messages and retry options for failed operations.

### 7. **Modern UI/UX**
- Built with SwiftUI for a responsive and visually appealing interface.
- Uses SwiftData for efficient local data management.

---

## Project Structure

- **Models/**: Data models for movies, genres, collections, cast, reviews, and user.
- **Network/**: Networking layer for API requests and data fetching.
- **Persistence/**: Local and remote data storage management.
- **Presentation/**: SwiftUI views and screens for all app features.
- **Stores/**: State management for movies, users, and navigation.
- **ErrorHandling/**: Centralized error handling utilities.
- **Extensions/**: Utility extensions for networking and data handling.
- **Stubs/**: JSON files for development and preview data.

---

## Possible Future Updates & Feature Implementation Plan

### 1. **Push Notifications**
- Notify users about new movie releases, reviews, or updates to their favorite movies.

### 2. **Social Features**
- Allow users to follow each other, share favorite lists, and comment on reviews.

### 3. **Offline Mode**
- Cache movie data and user actions for offline access and synchronization.

### 4. **Advanced Search & Filtering**
- Add filters for year, rating, language, and more advanced search capabilities.

### 5. **Personalized Recommendations**
- Suggest movies based on user preferences, watch history, and reviews.

### 6. **Watchlist**
- Allow users to create and manage a watchlist separate from favorites.

### 7. **Localization**
- Support for multiple languages to reach a broader audience.

### 8. **Accessibility Improvements**
- Enhance accessibility for users with disabilities (VoiceOver, Dynamic Type, etc.).

### 9. **App Clips & Widgets**
- Provide quick access to trending movies or favorites via widgets and App Clips.

### 10. **Admin Panel**
- Add an admin interface for managing movie data, reviews, and user reports.

---

## Getting Started

1. **Clone the repository**
2. **Install dependencies** (via Swift Package Manager and CocoaPods if needed for Firebase)
3. **Configure Firebase**
   - Add your `GoogleService-Info.plist` to the project.
4. **Build and run** on a device or simulator running iOS 18.1 or later.

---

## Contributing

Contributions are welcome! Please open issues or submit pull requests for new features, bug fixes, or improvements.

---

## License

MIT License (or your preferred license) 