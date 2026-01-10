import 'package:dio/dio.dart';

/// HTTP API client for making REST API calls.
///
/// This class provides typed methods for all API endpoints used in the application.
/// It wraps Dio HTTP client and handles response parsing.
///
/// Example:
/// ```dart
/// final apiClient = ApiClient(dio);
/// final userData = await apiClient.login({'email': 'test@example.com', 'password': '1234'});
/// ```
class ApiClient {
  final Dio _dio;

  /// Creates an [ApiClient] with the given [Dio] instance.
  ///
  /// The Dio instance should be pre-configured with base URL and interceptors.
  ApiClient(this._dio);

  // ============ Auth Endpoints ============

  /// Authenticates a user with their credentials.
  ///
  /// [loginData] should contain 'email' and 'password' fields.
  /// Returns user data and authentication tokens on success.
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginData) async {
    final response = await _dio.post('/auth/login', data: loginData);
    return response.data as Map<String, dynamic>;
  }

  /// Registers a new user account.
  ///
  /// [registerData] should contain 'email', 'password', and 'username' fields.
  /// Returns the newly created user data on success.
  Future<Map<String, dynamic>> register(Map<String, dynamic> registerData) async {
    final response = await _dio.post('/auth/register', data: registerData);
    return response.data as Map<String, dynamic>;
  }

  /// Refreshes the authentication token.
  ///
  /// [refreshData] should contain the 'refreshToken' field.
  /// Returns new access and refresh tokens on success.
  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> refreshData) async {
    final response = await _dio.post('/auth/refresh', data: refreshData);
    return response.data as Map<String, dynamic>;
  }

  // ============ Feed Endpoints ============

  /// Retrieves a paginated list of posts.
  ///
  /// [page] is the page number to retrieve (1-indexed).
  /// [limit] is the number of posts per page.
  /// Returns a list of post data maps.
  Future<List<Map<String, dynamic>>> getPosts(int page, int limit) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  /// Creates a new post.
  ///
  /// [postData] should contain 'content' and optionally 'imageUrls' fields.
  /// Returns the created post data on success.
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    final response = await _dio.post('/posts', data: postData);
    return response.data as Map<String, dynamic>;
  }

  /// Retrieves a single post by its ID.
  ///
  /// [id] is the unique identifier of the post.
  /// Returns the post data including author information.
  Future<Map<String, dynamic>> getPost(String id) async {
    final response = await _dio.get('/posts/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Adds a like to a post.
  ///
  /// [id] is the unique identifier of the post to like.
  Future<void> likePost(String id) async {
    await _dio.put('/posts/$id/like');
  }

  /// Removes a like from a post.
  ///
  /// [id] is the unique identifier of the post to unlike.
  Future<void> unlikePost(String id) async {
    await _dio.delete('/posts/$id/like');
  }
}
