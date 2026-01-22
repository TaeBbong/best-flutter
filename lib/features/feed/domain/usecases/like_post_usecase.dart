import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

/// Use case for updating the like count of a post.
///
/// Encapsulates the business logic for liking/unliking posts.
/// DummyJSON doesn't have dedicated like endpoints, so we update
/// the reactions count directly.
class LikePostUseCase {
  final FeedRepository _repository;

  /// Creates a [LikePostUseCase] with the given repository.
  LikePostUseCase(this._repository);

  /// Executes the like update operation.
  ///
  /// - [postId]: Unique identifier of the post.
  /// - [currentLikes]: Current number of likes on the post.
  /// - [like]: `true` to add a like, `false` to remove one.
  ///
  /// Returns a [Result] containing the updated [Post] on success,
  /// or a failure with error details.
  Future<Result<Post>> call({
    required int postId,
    required int currentLikes,
    required bool like,
  }) {
    final newLikes = like ? currentLikes + 1 : (currentLikes > 0 ? currentLikes - 1 : 0);
    return _repository.updateLikes(id: postId, likes: newLikes);
  }
}
