import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class GetPostsUseCase {
  final FeedRepository _repository;

  GetPostsUseCase(this._repository);

  Future<Result<List<Post>>> call({
    required int page,
    required int limit,
  }) {
    return _repository.getPosts(page: page, limit: limit);
  }
}
