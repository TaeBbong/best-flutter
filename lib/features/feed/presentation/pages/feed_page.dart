import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/feed_state_provider.dart';
import '../widgets/post_card.dart';

/// Main feed page displaying a scrollable list of posts.
///
/// Shows loading, error, and empty states appropriately.
/// Supports pull-to-refresh and infinite scroll pagination.
class FeedPage extends ConsumerWidget {
  /// Creates a [FeedPage] widget.
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.createPost),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.myPage),
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Failed to load feed',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              ElevatedButton.icon(
                onPressed: () => ref.read(feedProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (feedState) => _FeedContent(feedState: feedState),
      ),
    );
  }
}

/// Internal widget for displaying the feed content.
///
/// Shows an empty state message when no posts exist,
/// otherwise displays a scrollable list with pagination support.
class _FeedContent extends ConsumerWidget {
  /// Creates a [_FeedContent] widget with the given feed state.
  const _FeedContent({required this.feedState});

  /// The current feed state containing posts and pagination info.
  final FeedState feedState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (feedState.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'No posts yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Be the first to share something!',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.createPost),
              icon: const Icon(Icons.add),
              label: const Text('Create Post'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(feedProvider.notifier).refresh(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              ref.read(feedProvider.notifier).loadMore();
            }
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          itemCount: feedState.posts.length + (feedState.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: AppTheme.spacingMd),
          itemBuilder: (context, index) {
            if (index == feedState.posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.spacingMd),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final post = feedState.posts[index];
            return PostCard(
              post: post,
              onLike: () => ref.read(feedProvider.notifier).toggleLike(post.id),
              onTap: () => context.push('/post/${post.id}'),
            );
          },
        ),
      ),
    );
  }
}
