import '../../../../core/error/result.dart';
import '../entities/post.dart';

abstract class FeedRepository {
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  });

  Future<Result<Post>> createPost({
    required String content,
    List<String>? imageUrls,
  });

  Future<Result<Post>> getPost(String id);

  Future<Result<void>> likePost(String id);

  Future<Result<void>> unlikePost(String id);
}
