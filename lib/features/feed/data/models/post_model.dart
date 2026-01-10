import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

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

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

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
