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
  /// - [title]: Title of the post.
  /// - [body]: Body content of the post.
  /// - [userId]: ID of the user who created the post.
  /// - [tags]: List of tags associated with the post.
  /// - [likes]: Number of likes on the post.
  /// - [dislikes]: Number of dislikes on the post.
  /// - [views]: Number of views on the post.
  const factory Post({
    required int id,
    required String title,
    required String body,
    required int userId,
    @Default([]) List<String> tags,
    @Default(0) int likes,
    @Default(0) int dislikes,
    @Default(0) int views,
  }) = _Post;

  /// Creates a [Post] from a JSON map.
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
