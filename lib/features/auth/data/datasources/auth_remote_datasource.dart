import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  });

  Future<void> logout();

  Future<UserModel> getCurrentUser();

  Future<UserModel> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

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

      // 토큰 저장
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

      // 토큰 저장
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

      // JWT 토큰에서 user ID 추출하거나 별도 API 호출
      // 여기서는 간단히 저장된 user ID 사용
      final userId = await _secureStorage.read(key: AppConstants.userIdKey);
      if (userId == null) {
        throw const AuthException('No user ID found');
      }

      // 실제로는 API 호출: GET /users/me
      // 임시로 예외 처리
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

      // 실제 API 호출이 필요함
      // final response = await _apiClient.updateProfile(data);
      // return UserModel.fromJson(response);

      throw const AuthException('updateProfile not implemented');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}
