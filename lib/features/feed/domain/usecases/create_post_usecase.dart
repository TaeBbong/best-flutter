import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

/// Use case for creating a new post.
///
/// Encapsulates the business logic for creating posts in the feed.
class CreatePostUseCase {
  final FeedRepository _repository;

  /// Creates a [CreatePostUseCase] with the given repository.
  CreatePostUseCase(this._repository);

  /// Executes the create post operation.
  ///
  /// DummyJSON requires title, body, and userId for post creation.
  /// - [title]: Title of the post.
  /// - [body]: Body content of the post.
  /// - [userId]: ID of the user creating the post.
  ///
  /// Returns a [Result] containing the created [Post] on success,
  /// or a failure with error details.
  Future<Result<Post>> call({
    required String title,
    required String body,
    required int userId,
  }) {
    return _repository.createPost(
      title: title,
      body: body,
      userId: userId,
    );
  }
}
