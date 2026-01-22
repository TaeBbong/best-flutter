import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';

/// Card widget displaying a single post.
///
/// Shows post title, body content, tags, and action buttons
/// for liking and viewing details.
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
              // Title
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Body content
              Text(
                post.body,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingSm),

              // Tags
              if (post.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppTheme.spacingXs,
                  runSpacing: AppTheme.spacingXs,
                  children: post.tags.map((tag) {
                    return Chip(
                      label: Text(
                        '#$tag',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppTheme.spacingSm),
              ],

              // Stats and Actions
              Row(
                children: [
                  // Likes
                  _ActionButton(
                    icon: Icons.favorite_border,
                    label: '${post.likes}',
                    onPressed: onLike,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),

                  // Dislikes (display only)
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_down_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        '${post.dislikes}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppTheme.spacingMd),

                  // Views
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        '${post.views}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // User ID
                  Text(
                    'User #${post.userId}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action button for post interactions (like, etc.).
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
