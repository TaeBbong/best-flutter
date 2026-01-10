/// Application-wide constants.
///
/// Contains configuration values, storage keys, and default settings
/// used throughout the application.
class AppConstants {
  // ============ API Configuration ============

  /// Base URL for all API requests.
  static const String apiBaseUrl = 'https://api.example.com/v1';

  // ============ Storage Keys ============

  /// Secure storage key for the access token.
  static const String accessTokenKey = 'access_token';

  /// Secure storage key for the refresh token.
  static const String refreshTokenKey = 'refresh_token';

  /// Storage key for the current user's ID.
  static const String userIdKey = 'user_id';

  // ============ Pagination ============

  /// Default number of items per page for paginated requests.
  static const int defaultPageSize = 20;

  /// Maximum allowed items per page for paginated requests.
  static const int maxPageSize = 100;

  // ============ Timeouts ============

  /// Default timeout duration for network requests.
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Shorter timeout for quick operations.
  static const Duration shortTimeout = Duration(seconds: 10);

  // ============ Cache ============

  /// Duration before cached data expires and needs refresh.
  static const Duration cacheExpiration = Duration(hours: 24);

  // ============ App Info ============

  /// Display name of the application.
  static const String appName = 'Best Flutter';

  /// Current version of the application.
  static const String appVersion = '1.0.0';
}
