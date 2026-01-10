import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for user information from the API.
///
/// This model is used to parse API responses and convert between
/// the data layer and domain layer representations of a user.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  /// Creates a [UserModel] instance.
  ///
  /// - [id]: Unique identifier for the user.
  /// - [email]: User's email address.
  /// - [username]: User's display name.
  /// - [profileImageUrl]: Optional URL to the user's profile image.
  /// - [bio]: Optional user biography or description.
  /// - [createdAt]: Timestamp when the user account was created.
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? profileImageUrl,
    String? bio,
    required DateTime createdAt,
  }) = _UserModel;

  /// Creates a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      profileImageUrl: profileImageUrl,
      bio: bio,
      createdAt: createdAt,
    );
  }

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      profileImageUrl: user.profileImageUrl,
      bio: user.bio,
      createdAt: user.createdAt,
    );
  }
}
