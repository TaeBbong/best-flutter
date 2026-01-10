import '../../../../core/error/result.dart';
import '../repositories/feed_repository.dart';

class LikePostUseCase {
  final FeedRepository _repository;

  LikePostUseCase(this._repository);

  Future<Result<void>> call({required String postId, required bool like}) {
    if (like) {
      return _repository.likePost(postId);
    } else {
      return _repository.unlikePost(postId);
    }
  }
}
