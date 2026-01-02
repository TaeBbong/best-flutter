// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorUsername: json['authorUsername'] as String,
  authorProfileImageUrl: json['authorProfileImageUrl'] as String?,
  content: json['content'] as String,
  imageUrls: (json['imageUrls'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  likesCount: (json['likesCount'] as num).toInt(),
  commentsCount: (json['commentsCount'] as num).toInt(),
  isLiked: json['isLiked'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'authorId': instance.authorId,
  'authorUsername': instance.authorUsername,
  'authorProfileImageUrl': instance.authorProfileImageUrl,
  'content': instance.content,
  'imageUrls': instance.imageUrls,
  'likesCount': instance.likesCount,
  'commentsCount': instance.commentsCount,
  'isLiked': instance.isLiked,
  'createdAt': instance.createdAt.toIso8601String(),
};
