// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the [RouterNotifier] that tracks authentication state.

@ProviderFor(authRouterNotifier)
final authRouterProvider = AuthRouterNotifierProvider._();

/// Provider for the [RouterNotifier] that tracks authentication state.

final class AuthRouterNotifierProvider
    extends $FunctionalProvider<RouterNotifier, RouterNotifier, RouterNotifier>
    with $Provider<RouterNotifier> {
  /// Provider for the [RouterNotifier] that tracks authentication state.
  AuthRouterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRouterNotifierHash();

  @$internal
  @override
  $ProviderElement<RouterNotifier> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RouterNotifier create(Ref ref) {
    return authRouterNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouterNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouterNotifier>(value),
    );
  }
}

String _$authRouterNotifierHash() =>
    r'c8bfb4accb2d45c0739df4fb6e3d16f9f0cb5ef3';

/// Provider for the main [GoRouter] instance.
///
/// Configures the router with:
/// - Authentication-based redirects
/// - Route definitions for all pages
/// - Error page handling

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

/// Provider for the main [GoRouter] instance.
///
/// Configures the router with:
/// - Authentication-based redirects
/// - Route definitions for all pages
/// - Error page handling

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provider for the main [GoRouter] instance.
  ///
  /// Configures the router with:
  /// - Authentication-based redirects
  /// - Route definitions for all pages
  /// - Error page handling
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'aff965106d39c78493c8f1a9443a1a015ab0a5e4';
