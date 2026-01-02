import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../error/exceptions.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints
  @POST('/auth/login')
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> loginData);

  @POST('/auth/register')
  Future<Map<String, dynamic>> register(@Body() Map<String, dynamic> registerData);

  @POST('/auth/refresh')
  Future<Map<String, dynamic>> refreshToken(@Body() Map<String, dynamic> refreshData);

  // Feed endpoints
  @GET('/posts')
  Future<List<Map<String, dynamic>>> getPosts(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @POST('/posts')
  Future<Map<String, dynamic>> createPost(@Body() Map<String, dynamic> postData);

  @GET('/posts/{id}')
  Future<Map<String, dynamic>> getPost(@Path('id') String id);

  @PUT('/posts/{id}/like')
  Future<void> likePost(@Path('id') String id);

  @DELETE('/posts/{id}/like')
  Future<void> unlikePost(@Path('id') String id);
}
