import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // Auth endpoints
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginData) async {
    final response = await _dio.post('/auth/login', data: loginData);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> registerData) async {
    final response = await _dio.post('/auth/register', data: registerData);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> refreshData) async {
    final response = await _dio.post('/auth/refresh', data: refreshData);
    return response.data as Map<String, dynamic>;
  }

  // Feed endpoints
  Future<List<Map<String, dynamic>>> getPosts(int page, int limit) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    final response = await _dio.post('/posts', data: postData);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPost(String id) async {
    final response = await _dio.get('/posts/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<void> likePost(String id) async {
    await _dio.put('/posts/$id/like');
  }

  Future<void> unlikePost(String id) async {
    await _dio.delete('/posts/$id/like');
  }
}
