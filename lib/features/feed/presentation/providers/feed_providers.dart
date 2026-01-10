import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/feed_remote_datasource.dart';
import '../../data/repositories/feed_repository_impl.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';

part 'feed_providers.g.dart';

// Data Source Provider
@riverpod
FeedRemoteDataSource feedRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeedRemoteDataSourceImpl(apiClient);
}

// Repository Provider
@riverpod
FeedRepository feedRepository(Ref ref) {
  final remoteDataSource = ref.watch(feedRemoteDataSourceProvider);
  return FeedRepositoryImpl(remoteDataSource);
}

// UseCase Providers
@riverpod
GetPostsUseCase getPostsUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return GetPostsUseCase(repository);
}

@riverpod
CreatePostUseCase createPostUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return CreatePostUseCase(repository);
}

@riverpod
LikePostUseCase likePostUseCase(Ref ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return LikePostUseCase(repository);
}
