import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Abstract interface for authentication remote data operations.
///
/// Defines the contract for API calls related to authentication.
abstract class AuthRemoteDataSource {
  /// Authenticates a user with username and password.
  ///
  /// DummyJSON uses username instead of email for login.
  /// Returns a [UserModel] on successful authentication.
  /// Throws [AuthException] if authentication fails.
  Future<UserModel> login({
    required String username,
    required String password,
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
}

/// Implementation of [AuthRemoteDataSource] using the API client.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  /// Creates an [AuthRemoteDataSourceImpl] with the given dependencies.
  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.login({
        'username': username,
        'password': password,
      });

      // DummyJSON returns user data and tokens in the same response
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

      // Store user ID for later use
      final userId = response['id'] as int;
      await _secureStorage.write(
        key: AppConstants.userIdKey,
        value: userId.toString(),
      );

      // DummyJSON returns user data directly in the login response
      return UserModel.fromJson(response);
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

      // DummyJSON provides /auth/me endpoint to get current user
      final response = await _apiClient.getCurrentUser();
      return UserModel.fromJson(response);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
