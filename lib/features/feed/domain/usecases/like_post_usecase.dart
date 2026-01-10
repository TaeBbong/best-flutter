import '../../../../core/error/result.dart';
import '../repositories/feed_repository.dart';

/// Use case for liking or unliking a post.
///
/// Encapsulates the business logic for toggling the like status of a post.
class LikePostUseCase {
  final FeedRepository _repository;

  /// Creates a [LikePostUseCase] with the given repository.
  LikePostUseCase(this._repository);

  /// Executes the like/unlike operation.
  ///
  /// - [postId]: Unique identifier of the post.
  /// - [like]: `true` to like the post, `false` to unlike it.
  ///
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> call({required String postId, required bool like}) {
    if (like) {
      return _repository.likePost(postId);
    } else {
      return _repository.unlikePost(postId);
    }
  }
}
