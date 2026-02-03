import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import 'package:best_flutter/features/feed/presentation/widgets/post_card.dart';

void main() {
  const testPost = Post(
    id: 1,
    title: 'Test Post Title',
    body: 'This is the body of the test post.',
    userId: 9,
    tags: ['flutter', 'dart'],
    likes: 42,
    dislikes: 3,
    views: 150,
  );

  Widget createTestWidget({
    required Post post,
    required VoidCallback onLike,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PostCard(
          post: post,
          onLike: onLike,
          onTap: onTap,
        ),
      ),
    );
  }

  group('PostCard', () {
    testWidgets('Given a post, When rendered, Then displays title and body', (tester) async {
      await tester.pumpWidget(createTestWidget(
        post: testPost,
        onLike: () {},
      ));

      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('This is the body of the test post.'), findsOneWidget);
    });

    testWidgets('Given a post with tags, When rendered, Then displays tags', (tester) async {
      await tester.pumpWidget(createTestWidget(
        post: testPost,
        onLike: () {},
      ));

      expect(find.text('#flutter'), findsOneWidget);
      expect(find.text('#dart'), findsOneWidget);
    });

    testWidgets('Given a post, When rendered, Then displays stats', (tester) async {
      await tester.pumpWidget(createTestWidget(
        post: testPost,
        onLike: () {},
      ));

      expect(find.text('42'), findsOneWidget); // likes
      expect(find.text('3'), findsOneWidget); // dislikes
      expect(find.text('150'), findsOneWidget); // views
      expect(find.text('User #9'), findsOneWidget); // userId
    });

    testWidgets('Given a post with no tags, When rendered, Then no chips are shown', (tester) async {
      const postWithoutTags = Post(
        id: 2,
        title: 'No Tags',
        body: 'Body',
        userId: 1,
      );

      await tester.pumpWidget(createTestWidget(
        post: postWithoutTags,
        onLike: () {},
      ));

      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('Given onLike callback, When like button is tapped, Then callback is invoked', (tester) async {
      bool likeTapped = false;

      await tester.pumpWidget(createTestWidget(
        post: testPost,
        onLike: () => likeTapped = true,
      ));

      // Find the like button by its icon
      final likeButton = find.byIcon(Icons.favorite_border);
      expect(likeButton, findsOneWidget);

      await tester.tap(likeButton);
      await tester.pumpAndSettle();

      expect(likeTapped, isTrue);
    });

    testWidgets('Given onTap callback, When card is tapped, Then callback is invoked', (tester) async {
      bool cardTapped = false;

      await tester.pumpWidget(createTestWidget(
        post: testPost,
        onLike: () {},
        onTap: () => cardTapped = true,
      ));

      // Tap on the title text (which is inside the InkWell)
      await tester.tap(find.text('Test Post Title'));
      await tester.pumpAndSettle();

      expect(cardTapped, isTrue);
    });

    testWidgets('Given a post with zero likes, When rendered, Then shows 0', (tester) async {
      const zeroLikesPost = Post(
        id: 3,
        title: 'Zero Likes',
        body: 'Body',
        userId: 1,
        likes: 0,
        dislikes: 0,
        views: 0,
      );

      await tester.pumpWidget(createTestWidget(
        post: zeroLikesPost,
        onLike: () {},
      ));

      // All three stats show '0'
      expect(find.text('0'), findsNWidgets(3));
    });
  });
}
