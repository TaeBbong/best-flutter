import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

/// Use case for retrieving a paginated list of posts.
///
/// Encapsulates the business logic for fetching posts from the feed.
class GetPostsUseCase {
  final FeedRepository _repository;

  /// Creates a [GetPostsUseCase] with the given repository.
  GetPostsUseCase(this._repository);

  /// Executes the get posts operation.
  ///
  /// - [page]: The page number to retrieve (1-indexed).
  /// - [limit]: Maximum number of posts per page.
  ///
  /// Returns a [Result] containing a list of [Post]s on success,
  /// or a failure with error details.
  Future<Result<List<Post>>> call({
    required int page,
    required int limit,
  }) {
    return _repository.getPosts(page: page, limit: limit);
  }
}
