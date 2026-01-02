import '../../../../core/error/result.dart';
import '../repositories/feed_repository.dart';

class LikePostUseCase {
  final FeedRepository _repository;

  LikePostUseCase(this._repository);

  Future<Result<void>> call(String postId) {
    return _repository.likePost(postId);
  }
}
