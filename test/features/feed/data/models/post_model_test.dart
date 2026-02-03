import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/features/feed/data/models/post_model.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('PostModel', () {
    test('Given valid JSON, When fromJson is called, Then creates correct model', () {
      final model = PostModel.fromJson(TestData.testPostJson);

      expect(model.id, 1);
      expect(model.title, 'His mother had always taught him');
      expect(model.body, contains('not to ever think'));
      expect(model.userId, 9);
      expect(model.tags, ['history', 'american', 'crime']);
      expect(model.reactions.likes, 192);
      expect(model.reactions.dislikes, 25);
      expect(model.views, 305);
    });

    test('Given PostModel, When toEntity is called, Then creates correct Post entity', () {
      final entity = TestData.testPostModel.toEntity();

      expect(entity, isA<Post>());
      expect(entity.id, 1);
      expect(entity.title, 'His mother had always taught him');
      expect(entity.userId, 9);
      expect(entity.tags, ['history', 'american', 'crime']);
      expect(entity.likes, 192);
      expect(entity.dislikes, 25);
      expect(entity.views, 305);
    });

    test('Given Post entity, When fromEntity is called, Then creates correct model', () {
      final model = PostModel.fromEntity(TestData.testPost);

      expect(model.id, 1);
      expect(model.title, 'His mother had always taught him');
      expect(model.userId, 9);
      expect(model.reactions.likes, 192);
      expect(model.reactions.dislikes, 25);
      expect(model.views, 305);
    });

    test('Given PostModel with default values, When created, Then has correct defaults', () {
      const model = PostModel(
        id: 1,
        title: 'Test',
        body: 'Body',
        userId: 1,
      );

      expect(model.tags, isEmpty);
      expect(model.reactions.likes, 0);
      expect(model.reactions.dislikes, 0);
      expect(model.views, 0);
    });

    test('Given two identical PostModels, When compared, Then are equal', () {
      final model1 = PostModel.fromJson(TestData.testPostJson);
      final model2 = PostModel.fromJson(TestData.testPostJson);

      expect(model1, equals(model2));
    });
  });

  group('ReactionsModel', () {
    test('Given valid JSON, When fromJson is called, Then creates correct model', () {
      final model = ReactionsModel.fromJson({'likes': 10, 'dislikes': 5});

      expect(model.likes, 10);
      expect(model.dislikes, 5);
    });

    test('Given default ReactionsModel, When created, Then has zero values', () {
      const model = ReactionsModel();

      expect(model.likes, 0);
      expect(model.dislikes, 0);
    });
  });
}
