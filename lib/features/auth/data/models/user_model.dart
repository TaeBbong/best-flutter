import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for user information from DummyJSON API.
///
/// This model is used to parse API responses and convert between
/// the data layer and domain layer representations of a user.
///
/// DummyJSON user response format:
/// - id: int
/// - username: string
/// - email: string
/// - firstName: string
/// - lastName: string
/// - image: string (profile image URL)
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  /// Creates a [UserModel] instance.
  ///
  /// - [id]: Unique identifier for the user.
  /// - [username]: User's username.
  /// - [email]: User's email address.
  /// - [firstName]: User's first name.
  /// - [lastName]: User's last name.
  /// - [image]: URL to the user's profile image.
  const factory UserModel({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String? image,
  }) = _UserModel;

  /// Creates a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() {
    return User(
      id: id.toString(),
      email: email,
      username: username,
      displayName: '$firstName $lastName',
      profileImageUrl: image,
    );
  }

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) {
    final nameParts = user.displayName?.split(' ') ?? ['', ''];
    return UserModel(
      id: int.tryParse(user.id) ?? 0,
      username: user.username,
      email: user.email,
      firstName: nameParts.isNotEmpty ? nameParts.first : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      image: user.profileImageUrl,
    );
  }
}
