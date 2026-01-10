import 'dart:async';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of [AuthRepository] using remote data source.
///
/// Handles the actual data operations for authentication, including
/// error handling and data transformation between layers.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StreamController<User?> _userController = StreamController<User?>.broadcast();

  /// Creates an [AuthRepositoryImpl] with the given data source.
  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      final user = userModel.toEntity();
      _userController.add(user);
      return Success(user);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        email: email,
        password: password,
        username: username,
      );
      final user = userModel.toEntity();
      _userController.add(user);
      return Success(user);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      _userController.add(null);
      return const Success(null);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      final user = userModel.toEntity();
      return Success(user);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final userModel = await _remoteDataSource.updateProfile(
        username: username,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );
      final user = userModel.toEntity();
      _userController.add(user);
      return Success(user);
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } catch (e) {
      return const Error(UnknownFailure('An unknown error occurred'));
    }
  }

  @override
  Stream<User?> get userStream => _userController.stream;

  /// Disposes of the user stream controller.
  ///
  /// Should be called when the repository is no longer needed.
  void dispose() {
    _userController.close();
  }
}
