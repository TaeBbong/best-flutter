import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_providers.g.dart';

// ============ Infrastructure Providers ============

/// Provider for [FlutterSecureStorage] instance.
///
/// Used for securely storing authentication tokens.
/// Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// Provider for configured [DioClient] instance.
///
/// Sets up Dio with interceptors for authentication and logging.
/// Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(secureStorage);
}

/// Provider for [ApiClient] instance.
///
/// Provides typed methods for all API endpoints.
/// Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiClient(dioClient.dio);
}

// ============ Data Layer Providers ============

/// Provider for [AuthRemoteDataSource] implementation.
///
/// Handles authentication API calls and token storage.
/// Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRemoteDataSourceImpl(apiClient, secureStorage);
}

/// Provider for [AuthRepository] implementation.
///
/// Bridges between use cases and data sources.
/// Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
}

// ============ UseCase Providers ============

/// Provider for [LoginUseCase].
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

/// Provider for [RegisterUseCase].
@riverpod
RegisterUseCase registerUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
}

/// Provider for [LogoutUseCase].
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

/// Provider for [GetCurrentUserUseCase].
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

// ============ Stream Providers ============

/// Provider for the user authentication state stream.
///
/// Emits the current user when authenticated, or null when logged out.
@riverpod
Stream<dynamic> userStream(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.userStream;
}
