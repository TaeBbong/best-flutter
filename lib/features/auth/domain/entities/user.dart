import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Represents an authenticated user in the application.
///
/// This is a domain entity that contains the core user data
/// independent of any data source implementation.
@freezed
abstract class User with _$User {
  /// Creates a [User] instance.
  ///
  /// - [id]: Unique identifier for the user.
  /// - [email]: User's email address.
  /// - [username]: User's display name.
  /// - [profileImageUrl]: Optional URL to the user's profile image.
  /// - [bio]: Optional user biography or description.
  /// - [createdAt]: Timestamp when the user account was created.
  const factory User({
    required String id,
    required String email,
    required String username,
    String? profileImageUrl,
    String? bio,
    required DateTime createdAt,
  }) = _User;

  /// Creates a [User] from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
