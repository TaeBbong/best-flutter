# CLAUDE.md - 프로젝트 컨텍스트

이 파일은 Claude가 프로젝트를 파악하기 위한 컨텍스트 정보를 담고 있습니다.

## 프로젝트 개요

**Best Flutter**는 프로덕션 레벨의 Flutter 앱 아키텍처를 학습하기 위한 SNS 앱 예제입니다.

- **SDK**: Dart ^3.10.4, Flutter
- **아키텍처**: Clean Architecture (Presentation → Domain ← Data)
- **상태 관리**: Riverpod 3.x + riverpod_generator 4.x
- **라우팅**: go_router 17.x
- **네트워크**: Dio (직접 사용, retrofit 미사용)
- **데이터 모델**: Freezed 3.x

## 핵심 기술 스택 버전 및 주의사항

### Freezed 3.x
- **중요**: `class` 대신 `abstract class` 사용 필수
- 커스텀 메서드가 필요한 Model 클래스는 `const ClassName._()` private 생성자 필요

```dart
// Entity (커스텀 메서드 없음)
@freezed
abstract class User with _$User {
  const factory User({...}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Model (toEntity 등 커스텀 메서드 있음)
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();  // 필수
  const factory UserModel({...}) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  User toEntity() => User(...);
}
```

### Riverpod 3.x + riverpod_generator 4.x
- **Provider 이름 규칙 변경**: `Notifier` 접미사가 provider 이름에서 제거됨
  - `AuthNotifier` 클래스 → `authProvider` (not `authNotifierProvider`)
  - `FeedNotifier` 클래스 → `feedProvider`
- **goRouter** 함수 → `goRouterProvider`
- `valueOrNull`은 deprecated → `value` 사용
- `.g.dart` 파일에서 정확한 provider 이름 확인 가능

### Dio 직접 사용 (Retrofit 미사용)
- retrofit의 `@RestApi` 어노테이션 제거
- `ApiClient` 클래스에서 Dio를 직접 주입받아 사용

```dart
class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await _dio.post('/auth/login', data: data);
    return response.data as Map<String, dynamic>;
  }
}
```

### Flutter Theme API
- `CardTheme` → `CardThemeData`
- `withOpacity(0.3)` → `withValues(alpha: 0.3)`
- Color hex 형식: `0xFFEC4899` (공백 없음)

### Logger
- `printTime: true` → `dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart`

### Exception/Failure 클래스
- super parameters 사용: `const NetworkException([super.message = 'Network error']);`

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/app_constants.dart      # API URL, 타임아웃 등
│   ├── error/
│   │   ├── exceptions.dart               # 예외 클래스 (Network, Server, Cache, Auth)
│   │   ├── failures.dart                 # 실패 클래스 (Result 패턴에서 사용)
│   │   └── result.dart                   # sealed class Result<T>
│   ├── network/
│   │   ├── api_client.dart               # Dio 기반 API 메서드
│   │   └── dio_client.dart               # Dio 인스턴스 + 인터셉터
│   ├── providers/                        # 공유 인프라 DI (전역)
│   │   ├── network_providers.dart        # dioClientProvider, apiClientProvider
│   │   └── storage_providers.dart        # secureStorageProvider
│   ├── router/app_router.dart            # GoRouter 설정 + 인증 기반 리다이렉트
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── utils/
│       ├── app_logger.dart               # Logger 래퍼
│       └── usecase_base.dart             # UseCase, NoParamsUseCase, StreamUseCase 추상 클래스
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/auth_remote_datasource.dart
│   │   │   ├── models/user_model.dart
│   │   │   └── repositories/auth_repository_impl.dart
│   │   ├── di/                           # Feature 전용 DI
│   │   │   └── auth_providers.dart       # dataSource, repository, usecase providers
│   │   ├── domain/
│   │   │   ├── entities/user.dart
│   │   │   ├── repositories/auth_repository.dart  # 추상체 (의존성 역전)
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── pages/login_page.dart
│   │       ├── providers/
│   │       │   └── auth_state_provider.dart # AuthNotifier (상태 관리만)
│   │       └── widgets/
│   │
│   └── feed/
│       ├── data/
│       │   ├── datasources/feed_remote_datasource.dart
│       │   ├── models/post_model.dart
│       │   └── repositories/feed_repository_impl.dart
│       ├── di/                           # Feature 전용 DI
│       │   └── feed_providers.dart       # dataSource, repository, usecase providers
│       ├── domain/
│       │   ├── entities/post.dart
│       │   ├── repositories/feed_repository.dart  # 추상체 (의존성 역전)
│       │   └── usecases/
│       │       ├── get_posts_usecase.dart
│       │       ├── create_post_usecase.dart
│       │       └── like_post_usecase.dart
│       └── presentation/
│           ├── pages/
│           │   ├── feed_page.dart
│           │   └── create_post_page.dart
│           ├── providers/
│           │   └── feed_state_provider.dart # FeedNotifier (상태 관리만)
│           └── widgets/post_card.dart
│
└── main.dart
```

## 주요 Provider 참조

### 공유 인프라 (core/providers/)
| 함수 | Provider 이름 | 용도 |
|------|--------------|------|
| `secureStorage` | `secureStorageProvider` | FlutterSecureStorage 인스턴스 |
| `dioClient` | `dioClientProvider` | Dio 클라이언트 (인터셉터 포함) |
| `apiClient` | `apiClientProvider` | API 호출 클라이언트 |

### Feature DI (features/*/di/)
| 함수 | Provider 이름 | 용도 |
|------|--------------|------|
| `authRepository` | `authRepositoryProvider` | AuthRepository 구현체 |
| `loginUseCase` | `loginUseCaseProvider` | 로그인 UseCase |
| `feedRepository` | `feedRepositoryProvider` | FeedRepository 구현체 |
| `getPostsUseCase` | `getPostsUseCaseProvider` | 피드 조회 UseCase |

### 상태 관리 (features/*/presentation/providers/)
| 클래스 | Provider 이름 | 용도 |
|--------|--------------|------|
| `AuthNotifier` | `authProvider` | 인증 상태 관리 |
| `FeedNotifier` | `feedProvider` | 피드 상태 관리 |

### 라우터 (core/router/)
| 클래스/함수 | Provider 이름 | 용도 |
|------------|--------------|------|
| `goRouter` 함수 | `goRouterProvider` | GoRouter 인스턴스 |
| `RouterNotifier` | `authRouterNotifierProvider` | 라우터 인증 상태 감지 |

## 빌드 명령어

```bash
# FVM 사용 시
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs

# FVM 미사용 시
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 분석
fvm flutter analyze

# 실행
fvm flutter run
```

## 최근 수정 이력

### 2026-01-12
1. **di**: Clean Architecture 준수를 위한 DI 구조 리팩토링
   - 공유 인프라 provider를 `core/providers/`로 이동 (DioClient, ApiClient, SecureStorage)
   - Feature별 DI를 `features/*/di/`로 분리 (DataSource, Repository, UseCase)
   - presentation layer에서 data layer 직접 import 제거 (계층 위반 해소)
   - presentation/providers/에는 상태 관리 Notifier만 유지

### 2026-01-10
1. **error**: Exception/Failure 클래스에 super parameters 적용
2. **network**: Retrofit 제거, Dio 직접 사용으로 변경
3. **theme**: Color hex 형식 수정, deprecated API 교체 (CardTheme, withOpacity)
4. **providers**: Riverpod provider 이름 업데이트 (authNotifierProvider → authProvider)
5. **models**: Freezed 3.x 호환을 위해 abstract class로 변경
6. **pages**: Provider 참조 업데이트
7. **usecase**: LikePostUseCase named parameters 추가, 타입 파라미터 T로 변경
8. **logger**: deprecated printTime 대체

## 코드 스타일

- 한국어 주석 사용
- Clean Architecture 계층 분리 준수
- Result 패턴으로 에러 처리 (`Result.success`, `Result.error`)
- Freezed로 불변 데이터 클래스 생성
