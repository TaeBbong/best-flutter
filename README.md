# Best Flutter - 비즈니스 수준의 Flutter 아키텍처 학습 프로젝트

이 프로젝트는 **프로덕션 레벨의 Flutter 앱 구조**를 학습하기 위한 SNS 앱 예제입니다.
Clean Architecture, Riverpod 3.0, go_router 등 현업에서 사용되는 최신 패턴과 라이브러리를 적용했습니다.

---

## 목차

1. [기술 스택](#기술-스택)
2. [프로젝트 구조](#프로젝트-구조)
3. [아키텍처 이해하기](#아키텍처-이해하기)
4. [Core 모듈 설명](#core-모듈-설명)
5. [Feature 모듈 설명](#feature-모듈-설명)
6. [왜 이렇게 설계했나?](#왜-이렇게-설계했나)
7. [새로운 기능 추가하기](#새로운-기능-추가하기)
8. [자주 하는 실수와 해결법](#자주-하는-실수와-해결법)
9. [더 공부하기](#더-공부하기)

---

## 기술 스택

### 핵심 라이브러리

| 라이브러리 | 버전 | 역할 | 왜 선택했나? |
|-----------|------|------|-------------|
| **flutter_riverpod** | 3.1.0 | 상태 관리 | Provider의 단점을 보완, 컴파일 타임 안전성, 의존성 주입 통합 |
| **riverpod_annotation** | 4.0.0 | 코드 생성 | 보일러플레이트 감소, 타입 안전성 향상 |
| **go_router** | 17.0.1 | 라우팅 | 선언적 라우팅, 딥링크 지원, 인증 기반 리다이렉트 |
| **dio** | 5.9.0 | HTTP 클라이언트 | 인터셉터, 요청 취소, 자동 재시도 지원 |
| **freezed** | 3.2.3 | 불변 클래스 | copyWith, JSON 직렬화, 패턴 매칭 자동 생성 |
| **flutter_secure_storage** | 10.0.0 | 보안 저장소 | 토큰 등 민감한 데이터 암호화 저장 |
| **logger** | 2.6.2 | 로깅 | 개발 중 디버깅을 위한 포맷팅된 로그 출력 |

### 시작하기

```bash
# 의존성 설치
dart pub get

# 코드 생성 (필수!)
dart run build_runner build --delete-conflicting-outputs

# 개발 중 자동 생성 (추천)
dart run build_runner watch --delete-conflicting-outputs

# 앱 실행
flutter run
```

---

## 프로젝트 구조

```
lib/
├── core/                          # 앱 전체에서 사용하는 공통 코드
│   ├── constants/                 # 상수 정의
│   │   └── app_constants.dart
│   ├── error/                     # 에러 처리 시스템
│   │   ├── exceptions.dart        # 예외 클래스
│   │   ├── failures.dart          # 실패 클래스
│   │   └── result.dart            # Result<T> 타입
│   ├── network/                   # 네트워크 계층
│   │   ├── api_client.dart        # Dio 기반 API 클라이언트
│   │   └── dio_client.dart        # Dio 설정 & 인터셉터
│   ├── router/                    # 라우팅
│   │   └── app_router.dart        # GoRouter 설정
│   ├── theme/                     # 앱 테마
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── utils/                     # 유틸리티
│       ├── app_logger.dart        # 로깅 유틸리티
│       └── usecase_base.dart      # UseCase 추상 클래스 (확장용)
│
├── features/                      # 기능별 모듈
│   ├── auth/                      # 인증 기능
│   │   ├── data/                  # 데이터 계층
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/                # 도메인 계층
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/          # 프레젠테이션 계층
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   │
│   └── feed/                      # 피드 기능
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart                      # 앱 진입점
```

---

## 아키텍처 이해하기

### Clean Architecture란?

이 프로젝트는 **Clean Architecture**를 Flutter에 맞게 적용했습니다.
핵심 아이디어는 **관심사의 분리(Separation of Concerns)**입니다.

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (UI, State Management, User Interaction)                   │
│  - Pages, Widgets                                           │
│  - Riverpod Providers, Notifiers                            │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│  (Business Logic, Use Cases)                                │
│  - Entities (순수한 비즈니스 모델)                             │
│  - Repository 인터페이스                                      │
│  - UseCases (비즈니스 로직 단위)                              │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                             │
│  (Data Access, External Services)                           │
│  - Models (API 응답 모델)                                    │
│  - DataSources (API 호출)                                   │
│  - Repository 구현체                                         │
└─────────────────────────────────────────────────────────────┘
```

### 의존성 방향

```
Presentation → Domain ← Data
     ↓           ↑        ↓
   [UI]    [비즈니스]   [API]
```

**중요**: Domain 계층은 다른 계층에 의존하지 않습니다!
- Presentation은 Domain을 알지만, Data를 직접 알지 못함
- Data는 Domain을 알지만, Presentation을 알지 못함
- Domain은 어떤 계층도 알지 못함 (순수한 Dart 코드)

### 데이터 흐름 예시: 로그인

```
1. [LoginPage] 사용자가 로그인 버튼 클릭
       ↓
2. [AuthNotifier.login()] 상태를 loading으로 변경
       ↓
3. [LoginUseCase] 비즈니스 로직 실행
       ↓
4. [AuthRepository] 인터페이스 호출
       ↓
5. [AuthRepositoryImpl] 실제 구현체가 DataSource 호출
       ↓
6. [AuthRemoteDataSource] API 호출 (Dio)
       ↓
7. [서버 응답] → UserModel로 파싱
       ↓
8. [UserModel.toEntity()] → User 엔티티로 변환
       ↓
9. [Result.success(user)] → UseCase로 반환
       ↓
10. [AuthNotifier] 상태 업데이트 (user 저장, loading 해제)
       ↓
11. [LoginPage] UI 자동 갱신 (ref.watch)
```

---

## Core 모듈 설명

### 1. Error Handling (`core/error/`)

#### 왜 이렇게 설계했나?

Flutter에서 에러 처리는 까다롭습니다. try-catch를 남발하면 코드가 지저분해지고,
에러 타입을 구분하기 어렵습니다. 이 프로젝트는 **Result 패턴**을 사용합니다.

```dart
// core/error/result.dart
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  });
}

class Success<T> extends Result<T> { ... }
class Error<T> extends Result<T> { ... }
```

#### 사용 예시

```dart
// UseCase에서 Result 반환
Future<Result<User>> login() async {
  try {
    final user = await dataSource.login();
    return Result.success(user);
  } on ServerException catch (e) {
    return Result.error(ServerFailure(e.message));
  }
}

// Notifier에서 Result 처리
final result = await loginUseCase(email: email, password: password);

result.fold(
  onSuccess: (user) {
    state = state.copyWith(user: user, isLoading: false);
  },
  onError: (failure) {
    state = state.copyWith(error: failure, isLoading: false);
  },
);
```

### 2. Network (`core/network/`)

#### DioClient - 왜 래핑했나?

Dio를 직접 사용하지 않고 래핑한 이유:

1. **인터셉터 중앙 관리**: 토큰 추가, 로깅, 에러 변환을 한 곳에서
2. **토큰 자동 갱신**: 401 응답 시 토큰 갱신 후 재시도
3. **테스트 용이성**: Mock Dio 주입 가능

```dart
// core/network/dio_client.dart
class DioClient {
  late final Dio dio;

  DioClient(FlutterSecureStorage secureStorage) {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.connectionTimeout,
    ));

    // 인터셉터 추가
    dio.interceptors.addAll([
      _authInterceptor(secureStorage),
      _loggingInterceptor(),
      _errorInterceptor(),
    ]);
  }
}
```

### 3. Router (`core/router/`)

#### go_router + Riverpod 통합

```dart
// core/router/app_router.dart

// 인증 상태 변경을 감지하는 Notifier
class AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AuthRouterNotifier(this._ref) {
    // AuthNotifier의 상태 변경 구독
    // Note: Riverpod 3.x에서 생성된 provider 이름은 authProvider
    _ref.listen(authProvider, (_, state) {
      if (_isAuth != state.isAuthenticated) {
        _isAuth = state.isAuthenticated;
        notifyListeners();  // GoRouter에 변경 알림
      }
    });
  }
}

// Note: Riverpod 3.x에서 생성된 provider 이름은 goRouterProvider
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final notifier = ref.watch(authRouterNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,  // 인증 상태 변경 시 라우트 재평가
    redirect: (context, state) {
      final isLoggedIn = notifier.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // 로그인한 상태에서 로그인 페이지 접근 시 홈으로
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },
    routes: [...],
  );
}
```

---

## Feature 모듈 설명

### Auth Feature 구조

```
auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart    # API 호출
│   ├── models/
│   │   └── user_model.dart                # 서버 응답 모델
│   └── repositories/
│       └── auth_repository_impl.dart      # Repository 구현
│
├── domain/
│   ├── entities/
│   │   └── user.dart                      # 비즈니스 모델
│   ├── repositories/
│   │   └── auth_repository.dart           # Repository 인터페이스
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── logout_usecase.dart
│
└── presentation/
    ├── pages/
    │   └── login_page.dart                # 로그인 UI
    ├── providers/
    │   ├── auth_providers.dart            # 의존성 Provider
    │   └── auth_state_provider.dart       # 상태 Notifier
    └── widgets/
```

### Entity vs Model - 왜 분리했나?

```dart
// domain/entities/user.dart - 비즈니스 모델 (순수)
// Note: freezed 3.x부터는 abstract class 사용 필수
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String username,
    String? profileImageUrl,
  }) = _User;
}

// data/models/user_model.dart - API 응답 모델
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();  // 커스텀 메서드 사용을 위한 private 생성자

  const factory UserModel({
    required String id,
    required String email,
    required String username,
    @JsonKey(name: 'profile_image_url')  // API 필드명 매핑
    String? profileImageUrl,
  }) = _UserModel;

  // Model → Entity 변환
  User toEntity() => User(
    id: id,
    email: email,
    username: username,
    profileImageUrl: profileImageUrl,
  );
}
```

**분리의 장점**:
- API 응답 구조가 바뀌어도 Entity는 그대로
- Entity는 UI와 비즈니스 로직에 최적화
- Model은 API 스펙에 맞춤 (snake_case 등)

### Riverpod Provider 구조

```dart
// presentation/providers/auth_providers.dart

// 1. 인프라 Provider (keepAlive: 앱 수명 동안 유지)
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

// 2. DataSource Provider
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSourceImpl(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageProvider),
  );
}

// 3. Repository Provider
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}

// 4. UseCase Provider
@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}
```

### State Provider 패턴

```dart
// presentation/providers/auth_state_provider.dart

class AuthState {
  final User? user;
  final bool isLoading;
  final Failure? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({...});
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();  // 초기 상태

  Future<void> login({required String email, required String password}) async {
    // 1. 로딩 시작
    state = state.copyWith(isLoading: true, clearError: true);

    // 2. UseCase 실행
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(email: email, password: password);

    // 3. 결과에 따라 상태 업데이트
    result.fold(
      onSuccess: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      onError: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
    );
  }
}
```

### Feed Feature - AsyncNotifier 활용

Feed는 비동기 초기화가 필요해서 `AsyncNotifier`를 사용합니다.

```dart
// presentation/providers/feed_state_provider.dart

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  Future<FeedState> build() async {
    // 자동으로 loading 상태 관리
    final posts = await _fetchPosts(page: 1);
    return FeedState(posts: posts, hasMore: posts.length >= 20);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final posts = await _fetchPosts(page: 1);
      return FeedState(posts: posts, hasMore: posts.length >= 20);
    });
  }

  // Optimistic Update 예시
  Future<void> toggleLike(String postId) async {
    final currentState = state.value;  // Note: valueOrNull은 deprecated
    if (currentState == null) return;

    // 1. 즉시 UI 업데이트 (낙관적)
    final updatedPosts = _toggleLikeInList(currentState.posts, postId);
    state = AsyncValue.data(currentState.copyWith(posts: updatedPosts));

    // 2. API 호출
    final result = await likePostUseCase(postId: postId);

    // 3. 실패 시 롤백
    result.fold(
      onSuccess: (_) {},  // 이미 업데이트됨
      onError: (_) {
        state = AsyncValue.data(currentState);  // 원래 상태로
      },
    );
  }
}
```

---

## 왜 이렇게 설계했나?

### 1. Riverpod vs Provider vs Bloc

| 기준 | Riverpod | Provider | Bloc |
|------|----------|----------|------|
| 타입 안전성 | 컴파일 타임 | 런타임 | 컴파일 타임 |
| 의존성 주입 | 내장 | 별도 필요 | 별도 필요 |
| 테스트 용이성 | 매우 좋음 | 보통 | 좋음 |
| 학습 곡선 | 중간 | 낮음 | 높음 |
| 보일러플레이트 | 적음 (코드 생성) | 적음 | 많음 |

**Riverpod 선택 이유**:
- `ref.watch`로 BuildContext 없이 어디서든 상태 접근
- Provider override로 테스트 시 쉽게 mock 주입
- `@riverpod` 어노테이션으로 보일러플레이트 최소화

### 2. go_router를 선택한 이유

```dart
// Navigator 2.0 직접 사용 - 복잡함
class MyRouterDelegate extends RouterDelegate<MyRoutePath> {
  // 수십 줄의 보일러플레이트...
}

// go_router 사용 - 간결함
GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => HomePage()),
    GoRoute(path: '/login', builder: (_, __) => LoginPage()),
  ],
)
```

### 3. Freezed를 사용하는 이유

```dart
// 수동 작성 - 반복적이고 에러 발생 가능
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  User copyWith({String? id, String? name}) {
    return User(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  bool operator ==(Object other) { ... }  // 20줄 이상...

  factory User.fromJson(Map<String, dynamic> json) { ... }
}

// Freezed 사용 - 간결하고 안전함
// Note: freezed 3.x부터는 abstract class 필수
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 4. Result 패턴 vs try-catch

```dart
// try-catch 남발 - 지저분함
try {
  final user = await login();
  setState(() { _user = user; });
} on NetworkException catch (e) {
  setState(() { _error = e.message; });
} on ServerException catch (e) {
  setState(() { _error = e.message; });
} catch (e) {
  setState(() { _error = 'Unknown error'; });
}

// Result 패턴 - 깔끔함
final result = await login();
result.fold(
  onSuccess: (user) => setState(() { _user = user; }),
  onError: (failure) => setState(() { _error = failure.message; }),
);
```

---

## 새로운 기능 추가하기

### 예시: 댓글(Comment) 기능 추가

#### Step 1: Domain 계층 먼저 (비즈니스 로직)

```dart
// 1. Entity 생성
// lib/features/feed/domain/entities/comment.dart
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required String authorId,
    required String authorUsername,
    required String content,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

// 2. Repository 인터페이스 확장
// lib/features/feed/domain/repositories/feed_repository.dart
abstract class FeedRepository {
  // 기존 메서드...

  Future<Result<List<Comment>>> getComments({
    required String postId,
    required int page,
    required int limit,
  });

  Future<Result<Comment>> createComment({
    required String postId,
    required String content,
  });
}

// 3. UseCase 생성
// lib/features/feed/domain/usecases/get_comments_usecase.dart
class GetCommentsUseCase {
  final FeedRepository _repository;

  GetCommentsUseCase(this._repository);

  Future<Result<List<Comment>>> call({
    required String postId,
    required int page,
    required int limit,
  }) {
    return _repository.getComments(postId: postId, page: page, limit: limit);
  }
}
```

#### Step 2: Data 계층 구현

```dart
// 1. Model 생성 (API 응답용)
// lib/features/feed/data/models/comment_model.dart
@freezed
abstract class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    required String id,
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'author_username') required String authorUsername,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Comment toEntity() => Comment(
    id: id,
    postId: postId,
    authorId: authorId,
    authorUsername: authorUsername,
    content: content,
    createdAt: createdAt,
  );
}

// 2. DataSource에 메서드 추가
// 3. Repository 구현체 업데이트
```

#### Step 3: API Client 업데이트

```dart
// core/network/api_client.dart
// Dio 직접 사용 방식으로 API 메서드 추가
class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<List<Map<String, dynamic>>> getComments(
    String postId, {
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/posts/$postId/comments',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createComment(
    String postId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post('/posts/$postId/comments', data: body);
    return response.data as Map<String, dynamic>;
  }
}
```

#### Step 4: Presentation 계층

```dart
// 1. Provider 추가
@riverpod
GetCommentsUseCase getCommentsUseCase(GetCommentsUseCaseRef ref) {
  return GetCommentsUseCase(ref.watch(feedRepositoryProvider));
}

// 2. State Provider 생성 (Family 패턴 - postId별로 다른 상태)
@riverpod
class CommentNotifier extends _$CommentNotifier {
  @override
  Future<List<Comment>> build(String postId) async {
    final useCase = ref.read(getCommentsUseCaseProvider);
    final result = await useCase(postId: postId, page: 1, limit: 20);
    return result.fold(
      onSuccess: (comments) => comments,
      onError: (failure) => throw failure,
    );
  }
}

// 3. UI에서 사용
class CommentSection extends ConsumerWidget {
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentNotifierProvider(postId));

    return commentsAsync.when(
      data: (comments) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

#### Step 5: 코드 생성 실행

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 새 기능 추가 체크리스트

- [ ] **Domain**: Entity 생성 (`@freezed`)
- [ ] **Domain**: Repository 인터페이스에 메서드 추가
- [ ] **Domain**: UseCase 생성
- [ ] **Data**: Model 생성 (`@freezed`, `@JsonKey`)
- [ ] **Data**: DataSource에 메서드 추가
- [ ] **Data**: Repository 구현체 업데이트
- [ ] **Core**: API Client에 엔드포인트 추가
- [ ] **Presentation**: Provider 추가
- [ ] **Presentation**: State/Notifier 생성 (필요시)
- [ ] **Presentation**: UI 생성
- [ ] `build_runner` 실행

---

## 자주 하는 실수와 해결법

### 1. build_runner 실행 안 함

**증상**: `_$ClassName` 찾을 수 없음 에러

```
Error: The getter '_$User' isn't defined for the class 'User'.
```

**해결**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. ref.watch vs ref.read 혼동

```dart
// 잘못된 예 - build에서 read 사용 (변경 감지 안 됨!)
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.read(myProvider);  // X
  return Text(state.value);
}

// 올바른 예 - build에서는 watch
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(myProvider);  // O
  return Text(state.value);
}

// 콜백에서는 read 사용
ElevatedButton(
  onPressed: () {
    ref.read(myProvider.notifier).doSomething();  // O
  },
)
```

**규칙**:
- `build()` 안 = `ref.watch()` (상태 변경 시 리빌드)
- 콜백/이벤트 핸들러 안 = `ref.read()` (일회성 읽기)

### 3. keepAlive 누락

**증상**: 화면 이동 후 돌아왔을 때 상태 초기화

```dart
// 문제 - 화면 벗어나면 dispose됨
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) { ... }

// 해결 - 앱 수명 동안 유지
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) { ... }
```

### 4. AsyncValue 처리 누락

```dart
// 잘못된 예 - AsyncValue 무시
final feedState = ref.watch(feedNotifierProvider);
return ListView(children: feedState.posts.map(...));  // 에러!

// 올바른 예 - when으로 상태별 처리
final feedAsync = ref.watch(feedNotifierProvider);
return feedAsync.when(
  data: (state) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
);
```

### 5. Freezed 3.x에서 class 대신 abstract class 미사용

**증상**: `mixin _$User on User` 관련 에러

```
Error: The type 'User' must be a class.
```

**해결**: freezed 3.x부터는 `abstract class` 사용 필수

```dart
// 잘못된 예 (freezed 2.x 스타일)
@freezed
class User with _$User {
  const factory User(...) = _User;
}

// 올바른 예 (freezed 3.x)
@freezed
abstract class User with _$User {
  const factory User(...) = _User;
}

// 커스텀 메서드가 필요한 경우 (Model 클래스 등)
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();  // private 생성자 필수

  const factory UserModel(...) = _UserModel;

  User toEntity() => User(...);  // 커스텀 메서드
}
```

### 6. Riverpod 3.x Provider 이름 혼동

**증상**: `authNotifierProvider`를 찾을 수 없음

```
Error: The getter 'authNotifierProvider' isn't defined.
```

**원인**: riverpod_generator 4.x에서 생성되는 provider 이름 규칙 변경

```dart
// Notifier 클래스 이름
class AuthNotifier extends _$AuthNotifier { ... }

// 잘못된 예 - 이전 버전 스타일
ref.watch(authNotifierProvider);  // X

// 올바른 예 - riverpod_generator 4.x
ref.watch(authProvider);  // O - 'Notifier' 접미사 제거됨

// 함수형 provider의 경우
@riverpod
GoRouter goRouter(GoRouterRef ref) { ... }

ref.watch(goRouterProvider);  // O
```

**팁**: 생성된 `.g.dart` 파일을 확인하면 정확한 provider 이름을 알 수 있습니다.

### 7. Freezed copyWith에서 null 처리

```dart
// 문제 - null로 설정하고 싶은데 안 됨
state = state.copyWith(error: null);  // error가 null이 아닌 경우 변경 안 됨

// 해결 - 명시적 플래그 사용
AuthState copyWith({
  Failure? error,
  bool clearError = false,  // 명시적 플래그
}) {
  return AuthState(
    error: clearError ? null : (error ?? this.error),
  );
}

state = state.copyWith(clearError: true);  // 이제 null로 설정됨
```

---

## 더 공부하기

### 공식 문서

- [Riverpod 공식 문서](https://riverpod.dev)
- [go_router 공식 문서](https://pub.dev/packages/go_router)
- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [Dio 공식 문서](https://pub.dev/packages/dio)

### 추천 아티클

- [Code With Andrea - Riverpod](https://codewithandrea.com/articles/flutter-state-management-riverpod/)
- [Code With Andrea - go_router](https://codewithandrea.com/articles/flutter-navigation-gorouter-go-vs-push/)
- [Reso Coder - Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

### 이 프로젝트에서 더 구현해볼 것

1. **RegisterPage** - 회원가입 UI
2. **PostDetailPage** - 포스트 상세 + 댓글
3. **ProfilePage** - 사용자 프로필 편집
4. **이미지 업로드** - image_picker + 서버 업로드
5. **푸시 알림** - Firebase Cloud Messaging
6. **오프라인 지원** - Hive/Isar 로컬 캐싱
7. **테스트 작성** - Unit, Widget, Integration 테스트

---

## 라이선스

이 프로젝트는 학습 목적으로 자유롭게 사용할 수 있습니다.

---

**Happy Coding!**