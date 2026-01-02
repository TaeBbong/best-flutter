import '../../../../core/error/result.dart';
import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository _repository;

  CreatePostUseCase(this._repository);

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
