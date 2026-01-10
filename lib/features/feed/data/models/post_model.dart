import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Data model for post information from the API.
///
/// This model is used to parse API responses and convert between
/// the data layer and domain layer representations of a post.
@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

  /// Creates a [PostModel] instance.
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
  const factory PostModel({
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
  }) = _PostModel;

  /// Creates a [PostModel] from a JSON map.
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  /// Converts this model to a domain [Post] entity.
  Post toEntity() {
    return Post(
      id: id,
      authorId: authorId,
      authorUsername: authorUsername,
      authorProfileImageUrl: authorProfileImageUrl,
      content: content,
      imageUrls: imageUrls,
      likesCount: likesCount,
      commentsCount: commentsCount,
      isLiked: isLiked,
      createdAt: createdAt,
    );
  }

  /// Creates a [PostModel] from a domain [Post] entity.
  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      authorId: post.authorId,
      authorUsername: post.authorUsername,
      authorProfileImageUrl: post.authorProfileImageUrl,
      content: post.content,
      imageUrls: post.imageUrls,
      likesCount: post.likesCount,
      commentsCount: post.commentsCount,
      isLiked: post.isLiked,
      createdAt: post.createdAt,
    );
  }
}
