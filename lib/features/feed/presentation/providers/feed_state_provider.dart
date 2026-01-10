import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/post.dart';
import 'feed_providers.dart';

part 'feed_state_provider.g.dart';

/// State class representing the current feed data and pagination info.
///
/// Contains the list of posts, pagination state, and loading indicators
/// for managing the feed UI state.
class FeedState {
  /// The list of posts currently loaded in the feed.
  final List<Post> posts;

  /// Whether there are more posts available to load.
  final bool hasMore;

  /// The current page number (1-indexed).
  final int currentPage;

  /// Whether a load more operation is in progress.
  final bool isLoadingMore;

  /// Creates a [FeedState] with the given values.
  ///
  /// - [posts]: List of posts (default empty).
  /// - [hasMore]: Whether more posts can be loaded (default true).
  /// - [currentPage]: Current page number (default 1).
  /// - [isLoadingMore]: Loading more indicator (default false).
  const FeedState({
    this.posts = const [],
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  /// Creates a copy of this state with optional new values.
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

/// Async notifier for managing feed state and operations.
///
/// Handles loading posts, pagination, creating new posts,
/// and toggling likes with optimistic updates.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  /// Number of posts to fetch per page.
  static const int _pageSize = 20;

  /// Builds the initial feed state by loading the first page.
  @override
  Future<FeedState> build() async {
    final posts = await _fetchPosts(page: 1);
    return FeedState(
      posts: posts,
      hasMore: posts.length >= _pageSize,
      currentPage: 1,
    );
  }

  /// Fetches posts for the given page from the repository.
  ///
  /// - [page]: The page number to fetch.
  ///
  /// Returns the list of posts or throws on failure.
  Future<List<Post>> _fetchPosts({required int page}) async {
    final getPostsUseCase = ref.read(getPostsUseCaseProvider);
    final result = await getPostsUseCase(page: page, limit: _pageSize);

    return result.fold(
      onSuccess: (posts) => posts,
      onError: (failure) => throw failure,
    );
  }

  /// Refreshes the feed by reloading the first page.
  ///
  /// Resets the state to loading and fetches fresh data.
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

  /// Loads the next page of posts if available.
  ///
  /// Does nothing if already loading or no more posts exist.
  /// Appends new posts to the existing list.
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

  /// Creates a new post with the given content.
  ///
  /// - [content]: Text content of the post.
  /// - [imageUrls]: Optional list of image URLs.
  ///
  /// Returns true on success, false on failure.
  /// On success, prepends the new post to the feed.
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

  /// Toggles the like status of a post.
  ///
  /// - [postId]: ID of the post to like/unlike.
  ///
  /// Uses optimistic updates for immediate UI feedback.
  /// Reverts on API failure.
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
