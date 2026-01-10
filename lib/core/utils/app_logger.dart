import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Application-wide logging utility.
///
/// Provides static methods for logging at different severity levels.
/// Uses pretty printing in debug mode and minimal output in release mode.
///
/// Example:
/// ```dart
/// AppLogger.debug('Fetching user data...');
/// AppLogger.info('User logged in successfully');
/// AppLogger.error('Failed to load posts', error, stackTrace);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  /// Logs a debug message.
  ///
  /// Use for detailed debugging information during development.
  /// Only visible in debug mode.
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an informational message.
  ///
  /// Use for general runtime information like successful operations.
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  ///
  /// Use for potentially problematic situations that don't prevent operation.
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  ///
  /// Use for recoverable errors that should be investigated.
  /// In production, consider sending to crash reporting service.
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    // In production, send to crash reporting service like Crashlytics
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message);
    // }
  }

  /// Logs a fatal error message.
  ///
  /// Use for critical errors that may cause application failure.
  /// In production, consider sending to crash reporting service with fatal flag.
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);

    // In production, send to crash reporting service like Crashlytics
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: message, fatal: true);
    // }
  }
}
