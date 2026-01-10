import '../../../../core/error/result.dart';
import '../entities/user.dart';

/// Abstract repository interface for authentication operations.
///
/// This interface defines the contract for authentication-related
/// data operations. Implementations handle the actual data source
/// interactions (API, local storage, etc.).
abstract class AuthRepository {
  /// Authenticates a user with email and password.
  ///
  /// Returns a [Result] containing the authenticated [User] on success,
  /// or a failure if authentication fails.
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user account.
  ///
  /// Returns a [Result] containing the newly created [User] on success,
  /// or a failure if registration fails.
  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
  });

  /// Logs out the current user.
  ///
  /// Clears authentication tokens and user data from storage.
  /// Returns a [Result] indicating success or failure.
  Future<Result<void>> logout();

  /// Retrieves the currently authenticated user.
  ///
  /// Returns a [Result] containing the current [User] if authenticated,
  /// or a failure if no user is logged in.
  Future<Result<User>> getCurrentUser();

  /// Updates the current user's profile information.
  ///
  /// Only provided fields will be updated; null values are ignored.
  /// Returns a [Result] containing the updated [User] on success.
  Future<Result<User>> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  });

  /// Stream of the current user's authentication state.
  ///
  /// Emits the current [User] when authenticated, or null when logged out.
  /// Useful for reactive UI updates based on auth state changes.
  Stream<User?> get userStream;
}
