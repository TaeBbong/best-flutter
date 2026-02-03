import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/features/auth/data/models/user_model.dart';
import 'package:best_flutter/features/auth/domain/entities/user.dart';
import '../../../../helpers/test_data.dart';

void main() {
  group('UserModel', () {
    test('Given valid JSON, When fromJson is called, Then creates correct model', () {
      final model = UserModel.fromJson(TestData.testUserJson);

      expect(model.id, 1);
      expect(model.username, 'emilys');
      expect(model.email, 'emily.johnson@x.dummyjson.com');
      expect(model.firstName, 'Emily');
      expect(model.lastName, 'Johnson');
      expect(model.image, 'https://dummyjson.com/icon/emilys/128');
    });

    test('Given UserModel, When toEntity is called, Then creates correct User entity', () {
      final entity = TestData.testUserModel.toEntity();

      expect(entity, isA<User>());
      expect(entity.id, '1');
      expect(entity.email, 'emily.johnson@x.dummyjson.com');
      expect(entity.username, 'emilys');
      expect(entity.displayName, 'Emily Johnson');
      expect(entity.profileImageUrl, 'https://dummyjson.com/icon/emilys/128');
    });

    test('Given User entity, When fromEntity is called, Then creates correct model', () {
      final model = UserModel.fromEntity(TestData.testUser);

      expect(model.id, 1);
      expect(model.username, 'emilys');
      expect(model.email, 'emily.johnson@x.dummyjson.com');
      expect(model.firstName, 'Emily');
      expect(model.lastName, 'Johnson');
      expect(model.image, 'https://dummyjson.com/icon/emilys/128');
    });

    test('Given UserModel with null image, When toEntity is called, Then profileImageUrl is null', () {
      const model = UserModel(
        id: 2,
        username: 'test',
        email: 'test@test.com',
        firstName: 'Test',
        lastName: 'User',
      );

      final entity = model.toEntity();
      expect(entity.profileImageUrl, isNull);
    });

    test('Given User with null displayName, When fromEntity is called, Then names are empty', () {
      const user = User(
        id: '1',
        email: 'test@test.com',
        username: 'test',
      );

      final model = UserModel.fromEntity(user);
      expect(model.firstName, '');
      expect(model.lastName, '');
    });

    test('Given two identical UserModels, When compared, Then are equal', () {
      final model1 = UserModel.fromJson(TestData.testUserJson);
      final model2 = UserModel.fromJson(TestData.testUserJson);

      expect(model1, equals(model2));
    });
  });
}
