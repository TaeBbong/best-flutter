import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/pages/edit_profile_page.dart';
import '../../features/auth/presentation/pages/help_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/my_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/feed/presentation/pages/create_post_page.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/feed/presentation/pages/post_detail_page.dart';

part 'app_router.g.dart';

/// Contains all route path constants used in the application.
///
/// Use these constants instead of hardcoding path strings to avoid typos
/// and enable easy refactoring.
abstract class AppRoutes {
  /// Splash screen route.
  static const splash = '/splash';

  /// Login page route.
  static const login = '/login';

  /// Registration page route.
  static const register = '/register';

  /// Main feed (home) page route.
  static const feed = '/';

  /// Create new post page route.
  static const createPost = '/create-post';

  /// Post detail page route with dynamic ID parameter.
  static const postDetail = '/post/:id';

  /// My page (profile/settings) route.
  static const myPage = '/my-page';

  /// Edit profile page route.
  static const editProfile = '/edit-profile';

  /// Settings page route.
  static const settings = '/settings';

  /// Help and support page route.
  static const help = '/help';
}

/// A ChangeNotifier that listens to authentication state changes.
///
/// This notifier is used by GoRouter to trigger route re-evaluation
/// when the user's authentication status changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuth = false;
  bool _isLoading = true;

  /// Creates a [RouterNotifier] that listens to the auth provider.
  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, state) {
      final isAuth = state.isAuthenticated;
      final isLoading = state.isLoading;
      if (_isAuth != isAuth || _isLoading != isLoading) {
        _isAuth = isAuth;
        _isLoading = isLoading;
        notifyListeners();
      }
    });
  }

  /// Returns `true` if the user is currently authenticated.
  bool get isAuthenticated => _isAuth;

  /// Returns `true` if authentication check is in progress.
  bool get isLoading => _isLoading;
}

/// Provider for the [RouterNotifier] that tracks authentication state.
@riverpod
RouterNotifier authRouterNotifier(Ref ref) {
  return RouterNotifier(ref);
}

/// Provider for the main [GoRouter] instance.
///
/// Configures the router with:
/// - Authentication-based redirects
/// - Route definitions for all pages
/// - Error page handling
@riverpod
GoRouter goRouter(Ref ref) {
  final notifier = ref.watch(authRouterProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoutes.feed,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = notifier.isAuthenticated;
      final isLoading = notifier.isLoading;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isRegistering = state.matchedLocation == AppRoutes.register;

      // Don't redirect while checking auth status
      if (isLoading) {
        return null;
      }

      // Redirect to login if accessing protected pages while not logged in.
      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return AppRoutes.login;
      }

      // Redirect to feed if already logged in and trying to access login/register
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return AppRoutes.feed;
      }

      return null;
    },
    routes: [
      // Feed (Home) route
      GoRoute(
        path: AppRoutes.feed,
        name: 'feed',
        builder: (context, state) => const FeedPage(),
      ),

      // Create Post route
      GoRoute(
        path: AppRoutes.createPost,
        name: 'createPost',
        builder: (context, state) => const CreatePostPage(),
      ),

      // Login route
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // My Page route
      GoRoute(
        path: AppRoutes.myPage,
        name: 'myPage',
        builder: (context, state) => const MyPage(),
      ),

      // Register route
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Post Detail route
      GoRoute(
        path: AppRoutes.postDetail,
        name: 'postDetail',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return PostDetailPage(postId: postId);
        },
      ),

      // Edit Profile route
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfilePage(),
      ),

      // Settings route
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Help route
      GoRoute(
        path: AppRoutes.help,
        name: 'help',
        builder: (context, state) => const HelpPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.feed),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
