import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
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

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
