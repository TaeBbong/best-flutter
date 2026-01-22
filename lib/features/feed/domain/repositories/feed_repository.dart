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
  /// DummyJSON requires title, body, and userId for post creation.
  /// - [title]: Title of the post.
  /// - [body]: Body content of the post.
  /// - [userId]: ID of the user creating the post.
  ///
  /// Returns a [Result] containing the created [Post] on success.
  Future<Result<Post>> createPost({
    required String title,
    required String body,
    required int userId,
  });

  /// Retrieves a single post by its ID.
  ///
  /// - [id]: Unique identifier of the post.
  ///
  /// Returns a [Result] containing the [Post] on success.
  Future<Result<Post>> getPost(int id);

  /// Updates the like count for a post.
  ///
  /// DummyJSON doesn't have dedicated like/unlike endpoints,
  /// so this updates the reactions count directly.
  ///
  /// - [id]: Unique identifier of the post.
  /// - [likes]: New like count.
  ///
  /// Returns a [Result] containing the updated [Post] on success.
  Future<Result<Post>> updateLikes({
    required int id,
    required int likes,
  });
}
