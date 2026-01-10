import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';
import '../utils/app_logger.dart';

/// Configured Dio HTTP client with interceptors for authentication,
/// logging, and error handling.
///
/// This class sets up Dio with:
/// - Base URL and default headers
/// - Automatic token injection for authenticated requests
/// - Token refresh on 401 responses
/// - Request/response logging in debug mode
/// - Error transformation to application exceptions
///
/// Example:
/// ```dart
/// final dioClient = DioClient(secureStorage);
/// final apiClient = ApiClient(dioClient.dio);
/// ```
class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  /// Creates a [DioClient] with the given secure storage for token management.
  ///
  /// Initializes Dio with base configuration and adds all interceptors.
  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  /// Returns the configured Dio instance for making HTTP requests.
  Dio get dio => _dio;

  /// Creates an interceptor for handling authentication tokens.
  ///
  /// On request: Injects the access token from secure storage if available.
  /// On 401 error: Attempts to refresh the token and retry the request.
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          try {
            final refreshToken = await _secureStorage.read(
              key: AppConstants.refreshTokenKey,
            );

            if (refreshToken != null) {
              final response = await _dio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              final newAccessToken = response.data['accessToken'];
              await _secureStorage.write(
                key: AppConstants.accessTokenKey,
                value: newAccessToken,
              );

              // Retry the original request with new token
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await _dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            // Refresh failed, clear tokens and let the error propagate
            AppLogger.warning('Token refresh failed', e);
            await _secureStorage.delete(key: AppConstants.accessTokenKey);
            await _secureStorage.delete(key: AppConstants.refreshTokenKey);
          }
        }
        handler.next(error);
      },
    );
  }

  /// Creates an interceptor for logging HTTP requests and responses.
  ///
  /// Logs request method, path, headers, and data.
  /// Logs response status code and data.
  /// Logs error status codes and messages.
  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.debug('REQUEST[${options.method}] => PATH: ${options.path}');
        AppLogger.debug('Headers: ${options.headers}');
        AppLogger.debug('Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.info('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        AppLogger.debug('Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.error(
          'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          error.message,
        );
        handler.next(error);
      },
    );
  }

  /// Creates an interceptor for transforming Dio errors to application exceptions.
  ///
  /// Converts [DioException] types to appropriate [AppException] subclasses.
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        final exception = _handleDioError(error);
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: exception,
          ),
        );
      },
    );
  }

  /// Converts a [DioException] to an appropriate [AppException].
  ///
  /// Maps timeout errors to [NetworkException], bad responses to [ServerException],
  /// and other errors to appropriate exception types.
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Server error';
        return ServerException(message, statusCode);

      case DioExceptionType.cancel:
        return const UnknownException('Request cancelled');

      default:
        return const NetworkException('Network error occurred');
    }
  }
}
