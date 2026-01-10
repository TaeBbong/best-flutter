import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Abstract interface for authentication remote data operations.
///
/// Defines the contract for API calls related to authentication.
abstract class AuthRemoteDataSource {
  /// Authenticates a user with email and password.
  ///
  /// Returns a [UserModel] on successful authentication.
  /// Throws [AuthException] if authentication fails.
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  ///
  /// Returns a [UserModel] of the newly created user.
  /// Throws [AuthException] if registration fails.
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  });

  /// Logs out the current user.
  ///
  /// Clears stored tokens from secure storage.
  /// Throws [AuthException] if logout fails.
  Future<void> logout();

  /// Retrieves the currently authenticated user's data.
  ///
  /// Returns a [UserModel] of the current user.
  /// Throws [AuthException] if no user is authenticated.
  Future<UserModel> getCurrentUser();

  /// Updates the current user's profile information.
  ///
  /// Returns a [UserModel] with the updated data.
  /// Throws [AuthException] if update fails.
  Future<UserModel> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  });
}

/// Implementation of [AuthRemoteDataSource] using the API client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  /// Creates an [AuthRemoteDataSourceImpl] with the given dependencies.
  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login({
        'email': email,
        'password': password,
      });

      // Store authentication tokens
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;

      await _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );
      await _secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );

      final userData = response['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _apiClient.register({
        'email': email,
        'password': password,
        'username': username,
      });

      // Store authentication tokens
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;

      await _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );
      await _secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: refreshToken,
      );

      final userData = response['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: AppConstants.accessTokenKey);
      await _secureStorage.delete(key: AppConstants.refreshTokenKey);
      await _secureStorage.delete(key: AppConstants.userIdKey);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
      if (token == null) {
        throw const AuthException('No token found');
      }

      // Extract user ID from JWT token or use stored value
      final userId = await _secureStorage.read(key: AppConstants.userIdKey);
      if (userId == null) {
        throw const AuthException('No user ID found');
      }

      // TODO: Implement API call: GET /users/me
      throw const AuthException('getCurrentUser not implemented');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (username != null) data['username'] = username;
      if (bio != null) data['bio'] = bio;
      if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

      // TODO: Implement API call
      // final response = await _apiClient.updateProfile(data);
      // return UserModel.fromJson(response);

      throw const AuthException('updateProfile not implemented');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
