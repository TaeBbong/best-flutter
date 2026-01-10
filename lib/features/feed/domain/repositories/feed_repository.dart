import '../../../../core/error/result.dart';
import '../entities/post.dart';

/// Abstract repository interface for feed operations.
///
/// This interface defines the contract for feed-related data operations.
/// Implementations handle the actual data source interactions.
abstract class FeedRepository {
  /// Retrieves a paginated list of posts.
  ///
  /// - [page]: The page number to retrieve (1-indexed).
  /// - [limit]: Maximum number of posts per page.
  ///
  /// Returns a [Result] containing a list of [Post]s on success.
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  });

  /// Creates a new post.
  ///
  /// - [content]: Text content of the post.
  /// - [imageUrls]: Optional list of image URLs to attach.
  ///
  /// Returns a [Result] containing the created [Post] on success.
  Future<Result<Post>> createPost({
    required String content,
    List<String>? imageUrls,
  });

  /// Retrieves a single post by its ID.
  ///
  /// - [id]: Unique identifier of the post.
  ///
  /// Returns a [Result] containing the [Post] on success.
  Future<Result<Post>> getPost(String id);

  /// Adds a like to a post.
  ///
  /// - [id]: Unique identifier of the post to like.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> likePost(String id);

  /// Removes a like from a post.
  ///
  /// - [id]: Unique identifier of the post to unlike.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> unlikePost(String id);
}
