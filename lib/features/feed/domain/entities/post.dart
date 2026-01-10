import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// Represents a post in the feed.
///
/// This is a domain entity that contains the core post data
/// independent of any data source implementation.
@freezed
abstract class Post with _$Post {
  /// Creates a [Post] instance.
  ///
  /// - [id]: Unique identifier for the post.
  /// - [authorId]: ID of the user who created the post.
  /// - [authorUsername]: Display name of the post author.
  /// - [authorProfileImageUrl]: Optional URL to the author's profile image.
  /// - [content]: Text content of the post.
  /// - [imageUrls]: Optional list of image URLs attached to the post.
  /// - [likesCount]: Number of likes on the post.
  /// - [commentsCount]: Number of comments on the post.
  /// - [isLiked]: Whether the current user has liked this post.
  /// - [createdAt]: Timestamp when the post was created.
  const factory Post({
    required String id,
    required String authorId,
    required String authorUsername,
    String? authorProfileImageUrl,
    required String content,
    List<String>? imageUrls,
    required int likesCount,
    required int commentsCount,
    required bool isLiked,
    required DateTime createdAt,
  }) = _Post;

  /// Creates a [Post] from a JSON map.
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
