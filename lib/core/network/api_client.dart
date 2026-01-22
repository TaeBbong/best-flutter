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
  /// DummyJSON uses 'username' and 'password' fields for login.
  /// Returns user data and authentication tokens on success.
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginData) async {
    final response = await _dio.post('/auth/login', data: loginData);
    return response.data as Map<String, dynamic>;
  }

  /// Retrieves the currently authenticated user's data.
  ///
  /// Requires a valid access token in the Authorization header.
  /// Returns user data on success.
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
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

  /// Retrieves a user by their ID.
  ///
  /// [id] is the unique identifier of the user.
  /// Returns user data on success.
  Future<Map<String, dynamic>> getUser(int id) async {
    final response = await _dio.get('/users/$id');
    return response.data as Map<String, dynamic>;
  }

  // ============ Feed Endpoints ============

  /// Retrieves a paginated list of posts.
  ///
  /// DummyJSON uses 'limit' and 'skip' for pagination.
  /// [skip] is the number of posts to skip.
  /// [limit] is the number of posts per page.
  /// Returns response containing 'posts' array and pagination info.
  Future<Map<String, dynamic>> getPosts({
    required int skip,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Creates a new post.
  ///
  /// DummyJSON requires 'title' and 'userId' fields.
  /// Returns the created post data on success.
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    final response = await _dio.post('/posts/add', data: postData);
    return response.data as Map<String, dynamic>;
  }

  /// Retrieves a single post by its ID.
  ///
  /// [id] is the unique identifier of the post.
  /// Returns the post data.
  Future<Map<String, dynamic>> getPost(int id) async {
    final response = await _dio.get('/posts/$id');
    return response.data as Map<String, dynamic>;
  }

  /// Updates a post (simulates like by updating reactions).
  ///
  /// DummyJSON doesn't have a dedicated like endpoint,
  /// so we use PATCH to update the post.
  /// [id] is the unique identifier of the post.
  /// [data] contains the fields to update.
  Future<Map<String, dynamic>> updatePost(int id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/posts/$id', data: data);
    return response.data as Map<String, dynamic>;
  }
}
