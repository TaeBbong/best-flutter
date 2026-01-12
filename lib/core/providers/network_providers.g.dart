// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for configured [DioClient] instance.
///
/// Sets up Dio with interceptors for authentication and logging.
/// Kept alive for the app's lifetime.

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// Provider for configured [DioClient] instance.
///
/// Sets up Dio with interceptors for authentication and logging.
/// Kept alive for the app's lifetime.

final class DioClientProvider
    extends $FunctionalProvider<DioClient, DioClient, DioClient>
    with $Provider<DioClient> {
  /// Provider for configured [DioClient] instance.
  ///
  /// Sets up Dio with interceptors for authentication and logging.
  /// Kept alive for the app's lifetime.
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<DioClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DioClient create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DioClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DioClient>(value),
    );
  }
}

String _$dioClientHash() => r'4d7abbe974016e536a3e41b1bba1e4004cde168f';

/// Provider for [ApiClient] instance.
///
/// Provides typed methods for all API endpoints.
/// Kept alive for the app's lifetime.

@ProviderFor(apiClient)
final apiClientProvider = ApiClientProvider._();

/// Provider for [ApiClient] instance.
///
/// Provides typed methods for all API endpoints.
/// Kept alive for the app's lifetime.

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// Provider for [ApiClient] instance.
  ///
  /// Provides typed methods for all API endpoints.
  /// Kept alive for the app's lifetime.
  ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'334182514caf19221176d0d0fb9c498d0ce800bf';
