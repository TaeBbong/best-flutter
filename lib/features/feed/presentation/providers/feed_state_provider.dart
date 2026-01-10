import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/post.dart';
import 'feed_providers.dart';

part 'feed_state_provider.g.dart';

// Feed State
class FeedState {
  final List<Post> posts;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  const FeedState({
    this.posts = const [],
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  FeedState copyWith({
    List<Post>? posts,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Feed Notifier using AsyncNotifier for initial load
@riverpod
class FeedNotifier extends _$FeedNotifier {
  static const int _pageSize = 20;

  @override
  Future<FeedState> build() async {
    final posts = await _fetchPosts(page: 1);
    return FeedState(
      posts: posts,
      hasMore: posts.length >= _pageSize,
      currentPage: 1,
    );
  }

  Future<List<Post>> _fetchPosts({required int page}) async {
    final getPostsUseCase = ref.read(getPostsUseCaseProvider);
    final result = await getPostsUseCase(page: page, limit: _pageSize);

    return result.fold(
      onSuccess: (posts) => posts,
      onError: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final posts = await _fetchPosts(page: 1);
      return FeedState(
        posts: posts,
        hasMore: posts.length >= _pageSize,
        currentPage: 1,
      );
    });
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasMore || currentState.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = currentState.currentPage + 1;
      final newPosts = await _fetchPosts(page: nextPage);

      state = AsyncValue.data(
        currentState.copyWith(
          posts: [...currentState.posts, ...newPosts],
          hasMore: newPosts.length >= _pageSize,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> createPost({required String content, List<String>? imageUrls}) async {
    final createPostUseCase = ref.read(createPostUseCaseProvider);
    final result = await createPostUseCase(content: content, imageUrls: imageUrls);

    return result.fold(
      onSuccess: (post) {
        final currentState = state.value;
        if (currentState != null) {
          state = AsyncValue.data(
            currentState.copyWith(posts: [post, ...currentState.posts]),
          );
        }
        return true;
      },
      onError: (_) => false,
    );
  }

  Future<void> toggleLike(String postId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final postIndex = currentState.posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = currentState.posts[postIndex];
    final isCurrentlyLiked = post.isLiked;

    // Optimistic update
    final updatedPost = post.copyWith(
      isLiked: !isCurrentlyLiked,
      likesCount: isCurrentlyLiked ? post.likesCount - 1 : post.likesCount + 1,
    );

    final updatedPosts = [...currentState.posts];
    updatedPosts[postIndex] = updatedPost;
    state = AsyncValue.data(currentState.copyWith(posts: updatedPosts));

    // API call
    final likePostUseCase = ref.read(likePostUseCaseProvider);
    final result = await likePostUseCase(postId: postId, like: !isCurrentlyLiked);

    result.fold(
      onSuccess: (_) {
        // Already updated optimistically
      },
      onError: (_) {
        // Revert on error
        final revertedPosts = [...currentState.posts];
        revertedPosts[postIndex] = post;
        state = AsyncValue.data(currentState.copyWith(posts: revertedPosts));
      },
    );
  }
}