// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  userId: (json['userId'] as num).toInt(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  reactions: json['reactions'] == null
      ? const ReactionsModel()
      : ReactionsModel.fromJson(json['reactions'] as Map<String, dynamic>),
  views: (json['views'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
      'tags': instance.tags,
      'reactions': instance.reactions,
      'views': instance.views,
    };

_ReactionsModel _$ReactionsModelFromJson(Map<String, dynamic> json) =>
    _ReactionsModel(
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      dislikes: (json['dislikes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReactionsModelToJson(_ReactionsModel instance) =>
    <String, dynamic>{'likes': instance.likes, 'dislikes': instance.dislikes};
