import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/feed/presentation/pages/create_post_page.dart';
import '../../features/feed/presentation/pages/feed_page.dart';

part 'app_router.g.dart';

// Route paths
abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const feed = '/';
  static const createPost = '/create-post';
  static const postDetail = '/post/:id';
}

// Router Notifier for auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuth = false;

  RouterNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, state) {
      final isAuth = state.isAuthenticated;
      if (_isAuth != isAuth) {
        _isAuth = isAuth;
        notifyListeners();
      }
    });
  }

  bool get isAuthenticated => _isAuth;
}

@riverpod
RouterNotifier routerNotifier(RouterNotifierRef ref) {
  return RouterNotifier(ref);
}

@riverpod
GoRouter router(RouterRef ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoutes.feed,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = notifier.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isRegistering = state.matchedLocation == AppRoutes.register;

      // 로그인하지 않은 상태에서 보호된 페이지 접근 시 로그인으로 리다이렉트
      // 현재는 인증 없이도 피드를 볼 수 있도록 설정 (SNS 앱 특성)
      // 필요시 아래 주석 해제
      // if (!isLoggedIn && !isLoggingIn && !isRegistering) {
      //   return AppRoutes.login;
      // }

      // 이미 로그인한 상태에서 로그인/회원가입 페이지 접근 시 피드로 리다이렉트
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return AppRoutes.feed;
      }

      return null;
    },
    routes: [
      // Feed (Home)
      GoRoute(
        path: AppRoutes.feed,
        name: 'feed',
        builder: (context, state) => const FeedPage(),
      ),

      // Create Post
      GoRoute(
        path: AppRoutes.createPost,
        name: 'createPost',
        builder: (context, state) => const CreatePostPage(),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Register (TODO: RegisterPage 구현 필요)
      // GoRoute(
      //   path: AppRoutes.register,
      //   name: 'register',
      //   builder: (context, state) => const RegisterPage(),
      // ),

      // Post Detail (TODO: PostDetailPage 구현 필요)
      // GoRoute(
      //   path: AppRoutes.postDetail,
      //   name: 'postDetail',
      //   builder: (context, state) {
      //     final postId = state.pathParameters['id']!;
      //     return PostDetailPage(postId: postId);
      //   },
      // ),
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