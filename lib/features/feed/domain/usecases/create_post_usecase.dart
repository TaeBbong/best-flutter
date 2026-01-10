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
  /// - [content]: Text content of the post.
  /// - [imageUrls]: Optional list of image URLs to attach.
  ///
  /// Returns a [Result] containing the created [Post] on success,
  /// or a failure with error details.
  Future<Result<Post>> call({
    required String content,
    List<String>? imageUrls,
  }) {
    return _repository.createPost(
      content: content,
      imageUrls: imageUrls,
    );
  }
}
