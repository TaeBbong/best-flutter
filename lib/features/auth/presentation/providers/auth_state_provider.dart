import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user.dart';
import 'auth_providers.dart';

part 'auth_state_provider.g.dart';

/// Represents the authentication state of the application.
///
/// Holds the current user, loading status, and any error that occurred.
class AuthState {
  /// The currently authenticated user, or null if not logged in.
  final User? user;

  /// Whether an authentication operation is in progress.
  final bool isLoading;

  /// The error from the last failed operation, if any.
  final Failure? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Use [clearUser] to explicitly set user to null.
  /// Use [clearError] to explicitly set error to null.
  AuthState copyWith({
    User? user,
    bool? isLoading,
    Failure? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Returns `true` if a user is currently authenticated.
  bool get isAuthenticated => user != null;
}

/// Notifier that manages the authentication state.
///
/// Provides methods for login, register, logout, and error handling.
/// The state is kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();

  /// Attempts to log in with the given credentials.
  ///
  /// Sets [AuthState.isLoading] to true during the operation.
  /// On success, updates [AuthState.user] with the authenticated user.
  /// On failure, updates [AuthState.error] with the failure details.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(email: email, password: password);

    result.fold(
      onSuccess: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
    );
  }

  /// Attempts to register a new account with the given details.
  ///
  /// Sets [AuthState.isLoading] to true during the operation.
  /// On success, updates [AuthState.user] with the new user.
  /// On failure, updates [AuthState.error] with the failure details.
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      email: email,
      password: password,
      username: username,
    );

    result.fold(
      onSuccess: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
    );
  }

  /// Logs out the current user.
  ///
  /// Clears all user data and authentication tokens.
  /// On success, resets state to initial empty state.
  /// On failure, updates [AuthState.error] with the failure details.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();

    result.fold(
      onSuccess: (_) {
        state = const AuthState();
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
    );
  }

  /// Clears the current error from state.
  ///
  /// Should be called after displaying an error to the user.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
