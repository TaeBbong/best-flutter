import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/feed_remote_datasource.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';

part 'feed_providers.g.dart';

/// Provider for the feed remote data source.
///
/// Creates a [FeedRemoteDataSourceImpl] using the API client
/// from the auth providers.
@riverpod
FeedRemoteDataSource feedRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeedRemoteDataSourceImpl(apiClient);
}

/// Provider for the feed repository.
///
/// Creates a [FeedRepositoryImpl] using the remote data source.
@riverpod
FeedRepository feedRepository(Ref ref) {
  final remoteDataSource = ref.watch(feedRemoteDataSourceProvider);
  return FeedRepositoryImpl(remoteDataSource);
}

/// Provider for the get posts use case.
///
/// Creates a [GetPostsUseCase] for fetching paginated posts.
@riverpod
GetPostsUseCase getPostsUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return GetPostsUseCase(repository);
}

/// Provider for the create post use case.
///
/// Creates a [CreatePostUseCase] for creating new posts.
@riverpod
CreatePostUseCase createPostUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return CreatePostUseCase(repository);
}

/// Provider for the like post use case.
///
/// Creates a [LikePostUseCase] for toggling post likes.
@riverpod
LikePostUseCase likePostUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return LikePostUseCase(repository);
}
