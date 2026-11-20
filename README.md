# News App

A Flutter news app that lets users browse news by category and source, search for articles, and open full stories.

## Recent Updates

- Added a search screen with automatic search as the user types.
- Connected article search to the NewsAPI `/v2/everything` endpoint.
- Added loading, empty, and error states for search results.
- Added article previews and an option to open the full article in an in-app web view.
- Updated the Android and iOS launch screens with light and dark branding.
- Configured NewsAPI authentication through the `X-Api-Key` header.

## Demo

[Watch or download the app demo](assets/videos/news-app-demo.mp4).

## Run the App

Provide a NewsAPI key at runtime; do not commit the key to the repository.

```bash
flutter pub get
flutter run --dart-define=NEWS_API_KEY=YOUR_NEWS_API_KEY
```

## Built With

- Flutter and Dart
- NewsAPI
- Dio for HTTP requests
- Provider for state management
