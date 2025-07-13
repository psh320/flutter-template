# Profitable Flutter App Template

This template provides a professional, scalable, and production-ready foundation for building Flutter applications designed for monetization through ads. It comes pre-configured with a suite of best-in-class libraries and follows common patterns used by experienced Flutter developers.

## Architecture: Feature-First

This template follows a professional **Feature-First** architecture. This pattern is highly scalable and makes the codebase easy to navigate and maintain.

```
lib/
├── core/                  # Shared code across all features
│   ├── common_widgets/    # Shared widgets with business logic
│   ├── services/          # Singleton services (API, etc.)
│   └── widgets/           # Pure UI widgets (design system)
│
└── features/              # Each feature gets its own folder
    └── home/
        ├── data/
        ├── domain/
        └── presentation/
            ├── screens/
            └── widgets/   # Widgets used ONLY in the home feature
```

### The `core` Directory

- **`core/services`**: Houses singleton services like `ApiService` and `InAppPurchaseService`. These are registered with the `get_it` service locator.
- **`core/widgets`**: Contains pure, reusable UI widgets that form your app's design system (e.g., `PrimaryButton`). They should contain minimal to no business logic.
- **`core/common_widgets`**: This is for shared widgets that have their own business logic or state (e.g., a `TipOfTheDayCard` that fetches its own data). Use this for functional components needed across multiple features.

### The `features` Directory

Each folder inside `features` is a self-contained module. All the code related to a single feature (e.g., `home`, `settings`, `profile`) lives here. This makes it easy to work on a feature in isolation.

- **`presentation/screens`**: The main screen(s) for the feature.
- **`presentation/widgets`**: Widgets that are specific to this feature and are not used anywhere else (e.g., `SettingItem`).

This structure provides a clear and scalable path for growing your application.

---

## Core Libraries & Usage

This template is built on a foundation of carefully selected libraries. Here’s what each one does and how to use it.

### `flutter_riverpod` (State Management)

- **Purpose**: A powerful, compile-safe, and testable state management library. It handles caching, loading, and error states for asynchronous data, making it the Flutter equivalent of `react-query`.
- **Why it's here**: It provides a declarative way to manage and provide state to your UI, removing the need for `StatefulWidget` in many cases and simplifying data flow.
- **Example (`lib/screens/home_screen.dart`)**: We create a `FutureProvider` to fetch posts from our API. The UI then `watches` this provider and automatically rebuilds to show a loading indicator, the data, or an error message.

```dart
// 1. Define a provider that fetches data
final postsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = getIt<ApiService>();
  final response = await apiService.get('/posts');
  return response.data;
});

// 2. Use it in a ConsumerWidget
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The UI will react to changes in the provider's state
    final posts = ref.watch(postsProvider);

    return posts.when(
      data: (data) => ListView.builder(...),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
```

### `go_router` (Navigation)

- **Purpose**: A declarative routing package that simplifies navigation, handles deep linking, and uses the app's URL to manage state. It is maintained by the Flutter team.
- **Why it's here**: It provides a robust, URL-based navigation system that is essential for complex apps. The `ShellRoute` feature is perfect for persistent layouts, like our bottom navigation bar.
- **Example (`lib/router.dart` & `lib/main.dart`)**: We define routes in `router.dart` and use `context.go()` to navigate. The `AppShell` remains as a persistent UI shell for the nested routes.

```dart
// In your UI, navigate like this:
context.go('/settings');
```

### `dio` (Networking)

- **Purpose**: A powerful HTTP client for Dart, similar to `axios`. It supports interceptors, global configuration, file downloads, and more.
- **Why it's here**: It provides a robust and configurable way to interact with APIs. We've encapsulated it in an `ApiService` for clean, reusable, and testable network calls.
- **Example (`lib/services/api_service.dart`)**: The `ApiService` configures a `dio` instance with a base URL and a logging interceptor.

```dart
class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    // ...
  )) {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
```

### `get_it` (Service Locator)

- **Purpose**: A simple service locator that allows you to register and access services (like our `ApiService`) from anywhere in the app without using `BuildContext`.
- **Why it's here**: It decouples your UI from your services, making the app more modular and easier to test.
- **Example (`lib/service_locator.dart` & `lib/screens/home_screen.dart`)**: We register the `ApiService` as a singleton and then retrieve it inside our `postsProvider`.

```dart
// 1. Register the service (lib/service_locator.dart)
final getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());
}

// 2. Retrieve and use it anywhere
final apiService = getIt<ApiService>();
final response = await apiService.get('/posts');
```

### `google_mobile_ads` (Monetization)

- **Purpose**: The official plugin for integrating Google Mobile Ads (AdMob).
- **Why it's here**: This is the primary tool for monetizing the app. The template includes a ready-to-use banner ad implementation.
- **Example (`lib/main.dart`)**: The `AppShell` widget initializes, loads, and displays a `BannerAd` at the bottom of the screen.

```dart
class _AppShellState extends State<AppShell> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd(); // Loads the ad
  }

  // ... build method displays the ad in a SizedBox
}
```

### `firebase_core` & `firebase_database`

- **Purpose**: `firebase_core` is the entry point for connecting to your Firebase project. `firebase_database` provides access to the Realtime Database.
- **Why it's here**: Firebase is a powerful backend-as-a-service platform. This template makes its inclusion optional and simple to configure.
- **Example (`lib/config.dart` & `lib/main.dart`)**: Firebase is initialized conditionally based on the `useFirebase` flag.

```dart
// lib/config.dart
const bool useFirebase = true; // or false

// lib/main.dart
void main() async {
  // ...
  if (useFirebase) {
    await FirebaseService.initialize();
  }
  // ...
}
```