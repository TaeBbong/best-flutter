import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/post_model.dart';

/// Abstract interface for feed remote data operations.
///
/// Defines the contract for API calls related to the feed.
abstract class FeedRemoteDataSource {
  /// Retrieves a paginated list of posts.
  ///
  /// - [page]: The page number to retrieve (1-indexed).
  /// - [limit]: Maximum number of posts per page.
  ///
  /// Returns a list of [PostModel]s.
  /// Throws [ServerException] if the request fails.
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  });

  /// Creates a new post.
  ///
  /// - [content]: Text content of the post.
  /// - [imageUrls]: Optional list of image URLs to attach.
  ///
  /// Returns the created [PostModel].
  /// Throws [ServerException] if the request fails.
  Future<PostModel> createPost({
    required String content,
    List<String>? imageUrls,
  });

  /// Retrieves a single post by its ID.
  ///
  /// - [id]: Unique identifier of the post.
  ///
  /// Returns the [PostModel].
  /// Throws [ServerException] if the request fails.
  Future<PostModel> getPost(String id);

  /// Adds a like to a post.
  ///
  /// - [id]: Unique identifier of the post to like.
  ///
  /// Throws [ServerException] if the request fails.
  Future<void> likePost(String id);

  /// Removes a like from a post.
  ///
  /// - [id]: Unique identifier of the post to unlike.
  ///
  /// Throws [ServerException] if the request fails.
  Future<void> unlikePost(String id);
}

/// Implementation of [FeedRemoteDataSource] using the API client.
class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient _apiClient;

  /// Creates a [FeedRemoteDataSourceImpl] with the given API client.
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
