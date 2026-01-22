import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_state_provider.dart';

/// My page displaying user profile and settings.
///
/// Shows user information, profile editing options,
/// and logout functionality.
class MyPage extends ConsumerWidget {
  /// Creates a [MyPage] widget.
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
      ),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                children: [
                  // Profile header
                  _ProfileHeader(user: user),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Menu items
                  _MenuSection(
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Navigate to edit profile page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit profile coming soon'),
                            ),
                          );
                        },
                      ),
                      _MenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Navigate to settings page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings coming soon'),
                            ),
                          );
                        },
                      ),
                      _MenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          // TODO: Navigate to help page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Help & Support coming soon'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingMd),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  // App info
                  Text(
                    'Best Flutter v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Profile header showing user avatar and basic info.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: user?.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
          child: user?.profileImageUrl == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )
              : null,
        ),
        const SizedBox(height: AppTheme.spacingMd),

        // Display name
        Text(
          user?.displayName ?? user?.username ?? 'Guest',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.spacingXs),

        // Username
        if (user?.username != null)
          Text(
            '@${user.username}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        const SizedBox(height: AppTheme.spacingXs),

        // Email
        if (user?.email != null)
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
      ],
    );
  }
}

/// Section container for menu items.
class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}

/// Single menu item with icon, title, and tap action.
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
