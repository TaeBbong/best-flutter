import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';
import 'storage_providers.dart';

part 'network_providers.g.dart';

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
