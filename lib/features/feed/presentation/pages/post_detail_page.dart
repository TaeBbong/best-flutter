import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/result.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/feed_providers.dart';
import '../../domain/entities/post.dart';
import '../providers/feed_state_provider.dart';

/// Page displaying the full details of a single post.
///
/// Shows the post title, full body content, tags,
/// and interaction stats (likes, dislikes, views).
class PostDetailPage extends ConsumerStatefulWidget {
  /// Creates a [PostDetailPage] for the given post ID.
  const PostDetailPage({super.key, required this.postId});

  /// The ID of the post to display.
  final String postId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  Post? _post;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    final id = int.tryParse(widget.postId);
    if (id == null) {
      setState(() {
        _error = 'Invalid post ID';
        _isLoading = false;
      });
      return;
    }

    // Try to find the post in the feed state first
    final feedState = ref.read(feedProvider).value;
    if (feedState != null) {
      final cachedPost = feedState.posts.where((p) => p.id == id).firstOrNull;
      if (cachedPost != null) {
        setState(() {
          _post = cachedPost;
          _isLoading = false;
        });
        return;
      }
    }

    // Otherwise fetch from API
    final getPostUseCase = ref.read(getPostUseCaseProvider);
    final result = await getPostUseCase(id);

    result.fold(
      onSuccess: (post) {
        if (mounted) {
          setState(() {
            _post = post;
            _isLoading = false;
          });
        }
      },
      onError: (failure) {
        if (mounted) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
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
              _error!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadPost();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final post = _post!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Author info
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: AppTheme.spacingXs),
              Text(
                'User #${post.userId}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Body content
          Text(
            post.body,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Tags
          if (post.tags.isNotEmpty) ...[
            Wrap(
              spacing: AppTheme.spacingSm,
              runSpacing: AppTheme.spacingSm,
              children: post.tags.map((tag) {
                return Chip(
                  label: Text('#$tag'),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingLg),
          ],

          // Divider
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.favorite_border,
                label: '${post.likes}',
                description: 'Likes',
                onTap: () {
                  final id = int.tryParse(widget.postId);
                  if (id != null) {
                    ref.read(feedProvider.notifier).toggleLike(id);
                    setState(() {
                      _post = post.copyWith(likes: post.likes + 1);
                    });
                  }
                },
              ),
              _StatItem(
                icon: Icons.thumb_down_outlined,
                label: '${post.dislikes}',
                description: 'Dislikes',
              ),
              _StatItem(
                icon: Icons.visibility_outlined,
                label: '${post.views}',
                description: 'Views',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget displaying a stat item with icon, value, and description.
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppTheme.spacingXs),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
