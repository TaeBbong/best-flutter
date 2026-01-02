import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  });

  Future<PostModel> createPost({
    required String content,
    List<String>? imageUrls,
  });

  Future<PostModel> getPost(String id);

  Future<void> likePost(String id);

  Future<void> unlikePost(String id);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient _apiClient;

  FeedRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getPosts(page, limit);
      return response.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<PostModel> createPost({
    required String content,
    List<String>? imageUrls,
  }) async {
    try {
      final response = await _apiClient.createPost({
        'content': content,
        if (imageUrls != null) 'imageUrls': imageUrls,
      });
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<PostModel> getPost(String id) async {
    try {
      final response = await _apiClient.getPost(id);
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<void> likePost(String id) async {
    try {
      await _apiClient.likePost(id);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<void> unlikePost(String id) async {
    try {
      await _apiClient.unlikePost(id);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
