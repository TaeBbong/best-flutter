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
  /// - [title]: Title of the post.
  /// - [body]: Body content of the post.
  /// - [userId]: ID of the user creating the post.
  ///
  /// Returns the created [PostModel].
  /// Throws [ServerException] if the request fails.
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  });

  /// Retrieves a single post by its ID.
  ///
  /// - [id]: Unique identifier of the post.
  ///
  /// Returns the [PostModel].
  /// Throws [ServerException] if the request fails.
  Future<PostModel> getPost(int id);

  /// Updates a post's reactions (simulates like functionality).
  ///
  /// - [id]: Unique identifier of the post.
  /// - [likes]: New likes count.
  ///
  /// Returns the updated [PostModel].
  /// Throws [ServerException] if the request fails.
  Future<PostModel> updatePostReactions(int id, int likes);
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
      // DummyJSON uses skip instead of page
      // Convert page (1-indexed) to skip value
      final skip = (page - 1) * limit;
      final response = await _apiClient.getPosts(skip: skip, limit: limit);

      // DummyJSON returns { posts: [...], total: int, skip: int, limit: int }
      final posts = response['posts'] as List;
      return posts
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<PostModel> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await _apiClient.createPost({
        'title': title,
        'body': body,
        'userId': userId,
      });
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<PostModel> getPost(int id) async {
    try {
      final response = await _apiClient.getPost(id);
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<PostModel> updatePostReactions(int id, int likes) async {
    try {
      // DummyJSON doesn't have a dedicated like endpoint
      // We simulate by updating the post with new reaction count
      final response = await _apiClient.updatePost(id, {
        'reactions': {'likes': likes, 'dislikes': 0},
      });
      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
