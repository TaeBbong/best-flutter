import 'package:best_flutter/features/auth/data/models/user_model.dart';
import 'package:best_flutter/features/auth/domain/entities/user.dart';
import 'package:best_flutter/features/feed/data/models/post_model.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';

/// Test data factory for creating consistent test objects.
class TestData {
  // ============ User ============

  static const testUser = User(
    id: '1',
    email: 'emily.johnson@x.dummyjson.com',
    username: 'emilys',
    displayName: 'Emily Johnson',
    profileImageUrl: 'https://dummyjson.com/icon/emilys/128',
  );

  static const testUserModel = UserModel(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: 'https://dummyjson.com/icon/emilys/128',
  );

  static Map<String, dynamic> get testUserJson => {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'image': 'https://dummyjson.com/icon/emilys/128',
      };

  static Map<String, dynamic> get testLoginResponse => {
        ...testUserJson,
        'accessToken': 'test_access_token',
        'refreshToken': 'test_refresh_token',
      };

  // ============ Post ============

  static const testPost = Post(
    id: 1,
    title: 'His mother had always taught him',
    body: 'His mother had always taught him not to ever think of himself as better than others.',
    userId: 9,
    tags: ['history', 'american', 'crime'],
    likes: 192,
    dislikes: 25,
    views: 305,
  );

  static const testPostModel = PostModel(
    id: 1,
    title: 'His mother had always taught him',
    body: 'His mother had always taught him not to ever think of himself as better than others.',
    userId: 9,
    tags: ['history', 'american', 'crime'],
    reactions: ReactionsModel(likes: 192, dislikes: 25),
    views: 305,
  );

  static Map<String, dynamic> get testPostJson => {
        'id': 1,
        'title': 'His mother had always taught him',
        'body': 'His mother had always taught him not to ever think of himself as better than others.',
        'userId': 9,
        'tags': ['history', 'american', 'crime'],
        'reactions': {'likes': 192, 'dislikes': 25},
        'views': 305,
      };

  static List<Post> get testPostList => [
        testPost,
        const Post(
          id: 2,
          title: 'He was an old man',
          body: 'He was an old man who fished alone in the Gulf Stream.',
          userId: 13,
          tags: ['fiction', 'classic'],
          likes: 340,
          dislikes: 10,
          views: 1200,
        ),
      ];

  static List<PostModel> get testPostModelList => [
        testPostModel,
        const PostModel(
          id: 2,
          title: 'He was an old man',
          body: 'He was an old man who fished alone in the Gulf Stream.',
          userId: 13,
          tags: ['fiction', 'classic'],
          reactions: ReactionsModel(likes: 340, dislikes: 10),
          views: 1200,
        ),
      ];
}
