// 참고: 프로젝트가 커지고 UseCase가 많아질 경우 아래 추상 클래스 사용 고려
// 현재는 프로젝트 규모가 작아 개별 UseCase 클래스로 구현

import '../error/result.dart';

/// UseCase가 많아질 경우 사용할 수 있는 추상 클래스
///
/// 사용 예시:
/// ```dart
/// class LoginUseCase extends UseCase<User, LoginParams> {
///   final AuthRepository _repository;
///
///   LoginUseCase(this._repository);
///
///   @override
///   Future<Result<User>> call(LoginParams params) {
///     return _repository.login(
///       email: params.email,
///       password: params.password,
///     );
///   }
/// }
///
/// class LoginParams {
///   final String email;
///   final String password;
///
///   LoginParams({required this.email, required this.password});
/// }
/// ```
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// 파라미터가 없는 UseCase
abstract class NoParamsUseCase<T> {
  Future<Result<T>> call();
}

/// Stream을 반환하는 UseCase
abstract class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}
