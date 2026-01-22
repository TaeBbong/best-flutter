import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Data model for post information from DummyJSON API.
///
/// This model is used to parse API responses and convert between
/// the data layer and domain layer representations of a post.
///
/// DummyJSON post response format:
/// - id: int
/// - title: string
/// - body: string
/// - userId: int
/// - tags: string[]
/// - reactions: { likes: int, dislikes: int }
/// - views: int
@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

  /// Creates a [PostModel] instance.
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    required int userId,
    @Default([]) List<String> tags,
    @Default(ReactionsModel()) ReactionsModel reactions,
    @Default(0) int views,
  }) = _PostModel;

  /// Creates a [PostModel] from a JSON map.
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  /// Converts this model to a domain [Post] entity.
  Post toEntity() {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
      tags: tags,
      likes: reactions.likes,
      dislikes: reactions.dislikes,
      views: views,
    );
  }

  /// Creates a [PostModel] from a domain [Post] entity.
  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      userId: post.userId,
      tags: post.tags,
      reactions: ReactionsModel(likes: post.likes, dislikes: post.dislikes),
      views: post.views,
    );
  }
}

/// Model for the reactions object in DummyJSON posts.
@freezed
abstract class ReactionsModel with _$ReactionsModel {
  const factory ReactionsModel({
    @Default(0) int likes,
    @Default(0) int dislikes,
  }) = _ReactionsModel;

  factory ReactionsModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionsModelFromJson(json);
}
