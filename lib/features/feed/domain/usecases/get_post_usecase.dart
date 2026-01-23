import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

/// Use case for retrieving a single post by its ID.
///
/// Encapsulates the business logic for fetching a specific post.
class GetPostUseCase {
  final FeedRepository _repository;

  /// Creates a [GetPostUseCase] with the given repository.
  GetPostUseCase(this._repository);

  /// Executes the get post operation.
  ///
  /// - [id]: Unique identifier of the post to retrieve.
  ///
  /// Returns a [Result] containing the [Post] on success,
  /// or a failure with error details.
  Future<Result<Post>> call(int id) {
    return _repository.getPost(id);
  }
}
