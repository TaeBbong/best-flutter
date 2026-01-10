import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';

/// Card widget displaying a single post.
///
/// Shows author info, content, optional images, and action buttons
/// for liking, commenting, and sharing.
class PostCard extends StatelessWidget {
  /// Creates a [PostCard] with the given post data and callbacks.
  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    this.onTap,
  });

  /// The post data to display.
  final Post post;

  /// Callback when the like button is pressed.
  final VoidCallback onLike;

  /// Optional callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: post.authorProfileImageUrl != null
                        ? NetworkImage(post.authorProfileImageUrl!)
                        : null,
                    child: post.authorProfileImageUrl == null
                        ? Text(
                            post.authorUsername[0].toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        : null,
                  ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorUsername,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          _formatTimeAgo(post.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      // Show post options
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Content
              Text(
                post.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              // Images
              if (post.imageUrls != null && post.imageUrls!.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacingSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: post.imageUrls!.length == 1
                      ? Image.network(
                          post.imageUrls!.first,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Container(
                            height: 200,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: post.imageUrls!.length,
                            separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacingXs),
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              child: Image.network(
                                post.imageUrls![index],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Container(
                                  width: 200,
                                  height: 200,
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
              const SizedBox(height: AppTheme.spacingSm),

              // Actions
              Row(
                children: [
                  _ActionButton(
                    icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '${post.likesCount}',
                    color: post.isLiked ? Colors.red : null,
                    onPressed: onLike,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: '${post.commentsCount}',
                    onPressed: () {
                      // Open comments
                    },
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onPressed: () {
                      // Share post
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats a [DateTime] as a human-readable relative time string.
  ///
  /// Returns formats like "Just now", "5m ago", "2h ago", "3d ago",
  /// or the full date for posts older than a week.
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Action button for post interactions (like, comment, share).
///
/// Displays an icon and label with optional custom color.
class _ActionButton extends StatelessWidget {
  /// Creates an [_ActionButton] with the given properties.
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  /// The icon to display.
  final IconData icon;

  /// The label text to display.
  final String label;

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// Optional custom color for the icon and label.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXs,
          vertical: AppTheme.spacingXs,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: AppTheme.spacingXs),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color ?? Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
