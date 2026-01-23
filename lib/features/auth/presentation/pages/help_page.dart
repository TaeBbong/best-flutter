import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Help and support page.
///
/// Provides FAQ, contact information, and support resources.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // FAQ Section
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          _FaqItem(
            question: 'What is Best Flutter?',
            answer:
                'Best Flutter is a demo SNS app built to showcase production-level Flutter architecture using Clean Architecture, Riverpod, and GoRouter.',
          ),
          _FaqItem(
            question: 'How do I log in?',
            answer:
                'Use the test credentials: username "emilys" and password "emilyspass". This app uses the DummyJSON API for demo purposes.',
          ),
          _FaqItem(
            question: 'Why are my posts not saved?',
            answer:
                'This app uses DummyJSON, a mock API that simulates responses but does not persist data. Posts and changes will be lost when you restart the app.',
          ),
          _FaqItem(
            question: 'Can I create a new account?',
            answer:
                'DummyJSON does not support actual registration. The sign-up flow will log you in with a test account instead.',
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // Contact Section
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: const Text('support@bestflutter.dev'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('GitHub'),
                    subtitle: const Text('github.com/best-flutter'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingLg),

          // About section
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMd),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Flutter v1.0.0',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'A production-level Flutter app architecture example '
                    'for learning Clean Architecture, Riverpod state management, '
                    'and modern Flutter development patterns.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable FAQ item widget.
class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppTheme.spacingMd,
          0,
          AppTheme.spacingMd,
          AppTheme.spacingMd,
        ),
        children: [
          Text(
            answer,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
