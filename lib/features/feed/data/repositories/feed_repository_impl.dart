import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

/// Implementation of [FeedRepository] using remote data source.
///
/// Handles the actual data operations for the feed, including
/// error handling and data transformation between layers.
class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _remoteDataSource;

  /// Creates a [FeedRepositoryImpl] with the given data source.
  FeedRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final postModels = await _remoteDataSource.getPosts(
        page: page,
        limit: limit,
      );
      final posts = postModels.map((model) => model.toEntity()).toList();
      return Success(posts);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<Post>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final postModel = await _remoteDataSource.createPost(
        title: title,
        body: body,
        userId: userId,
      );
      return Success(postModel.toEntity());
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<Post>> getPost(int id) async {
    try {
      final postModel = await _remoteDataSource.getPost(id);
      return Success(postModel.toEntity());
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<Post>> updateLikes({
    required int id,
    required int likes,
  }) async {
    try {
      final postModel = await _remoteDataSource.updatePostReactions(id, likes);
      return Success(postModel.toEntity());
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }
}
