// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier that manages the authentication state.
///
/// Provides methods for login, register, logout, and error handling.
/// The state is kept alive for the app's lifetime.

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Notifier that manages the authentication state.
///
/// Provides methods for login, register, logout, and error handling.
/// The state is kept alive for the app's lifetime.
final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthState> {
  /// Notifier that manages the authentication state.
  ///
  /// Provides methods for login, register, logout, and error handling.
  /// The state is kept alive for the app's lifetime.
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authNotifierHash() => r'8fe7ad41aeaaec9944ca642de6ceee6e02eba0b6';

/// Notifier that manages the authentication state.
///
/// Provides methods for login, register, logout, and error handling.
/// The state is kept alive for the app's lifetime.

abstract class _$AuthNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
