class AppConstants {
  // API
  static const String apiBaseUrl = 'https://api.example.com/v1';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);

  // App
  static const String appName = 'Best Flutter';
  static const String appVersion = '1.0.0';
}