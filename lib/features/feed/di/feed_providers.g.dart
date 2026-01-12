// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the feed remote data source.
///
/// Creates a [FeedRemoteDataSourceImpl] using the API client.

@ProviderFor(feedRemoteDataSource)
final feedRemoteDataSourceProvider = FeedRemoteDataSourceProvider._();

/// Provider for the feed remote data source.
///
/// Creates a [FeedRemoteDataSourceImpl] using the API client.

final class FeedRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          FeedRemoteDataSource,
          FeedRemoteDataSource,
          FeedRemoteDataSource
        >
    with $Provider<FeedRemoteDataSource> {
  /// Provider for the feed remote data source.
  ///
  /// Creates a [FeedRemoteDataSourceImpl] using the API client.
  FeedRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<FeedRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeedRemoteDataSource create(Ref ref) {
    return feedRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedRemoteDataSource>(value),
    );
  }
}

String _$feedRemoteDataSourceHash() =>
    r'f1703e16ad715531a3f5b16f4e205632393e1c34';

/// Provider for the feed repository.
///
/// Creates a [FeedRepositoryImpl] using the remote data source.

@ProviderFor(feedRepository)
final feedRepositoryProvider = FeedRepositoryProvider._();

/// Provider for the feed repository.
///
/// Creates a [FeedRepositoryImpl] using the remote data source.

final class FeedRepositoryProvider
    extends $FunctionalProvider<FeedRepository, FeedRepository, FeedRepository>
    with $Provider<FeedRepository> {
  /// Provider for the feed repository.
  ///
  /// Creates a [FeedRepositoryImpl] using the remote data source.
  FeedRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedRepositoryHash();

  @$internal
  @override
  $ProviderElement<FeedRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FeedRepository create(Ref ref) {
    return feedRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedRepository>(value),
    );
  }
}

String _$feedRepositoryHash() => r'e1a7457b9de9935c1cef0763d9e02434e2846be6';

/// Provider for the get posts use case.
///
/// Creates a [GetPostsUseCase] for fetching paginated posts.

@ProviderFor(getPostsUseCase)
final getPostsUseCaseProvider = GetPostsUseCaseProvider._();

/// Provider for the get posts use case.
///
/// Creates a [GetPostsUseCase] for fetching paginated posts.

final class GetPostsUseCaseProvider
    extends
        $FunctionalProvider<GetPostsUseCase, GetPostsUseCase, GetPostsUseCase>
    with $Provider<GetPostsUseCase> {
  /// Provider for the get posts use case.
  ///
  /// Creates a [GetPostsUseCase] for fetching paginated posts.
  GetPostsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPostsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPostsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPostsUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetPostsUseCase create(Ref ref) {
    return getPostsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPostsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPostsUseCase>(value),
    );
  }
}

String _$getPostsUseCaseHash() => r'04d5994957f2449d155ea1dd292de1225b6792d9';

/// Provider for the create post use case.
///
/// Creates a [CreatePostUseCase] for creating new posts.

@ProviderFor(createPostUseCase)
final createPostUseCaseProvider = CreatePostUseCaseProvider._();

/// Provider for the create post use case.
///
/// Creates a [CreatePostUseCase] for creating new posts.

final class CreatePostUseCaseProvider
    extends
        $FunctionalProvider<
          CreatePostUseCase,
          CreatePostUseCase,
          CreatePostUseCase
        >
    with $Provider<CreatePostUseCase> {
  /// Provider for the create post use case.
  ///
  /// Creates a [CreatePostUseCase] for creating new posts.
  CreatePostUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createPostUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createPostUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreatePostUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreatePostUseCase create(Ref ref) {
    return createPostUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatePostUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatePostUseCase>(value),
    );
  }
}

String _$createPostUseCaseHash() => r'd88ae9f0732694db221979f105b864a8e37e3597';

/// Provider for the like post use case.
///
/// Creates a [LikePostUseCase] for toggling post likes.

@ProviderFor(likePostUseCase)
final likePostUseCaseProvider = LikePostUseCaseProvider._();

/// Provider for the like post use case.
///
/// Creates a [LikePostUseCase] for toggling post likes.

final class LikePostUseCaseProvider
    extends
        $FunctionalProvider<LikePostUseCase, LikePostUseCase, LikePostUseCase>
    with $Provider<LikePostUseCase> {
  /// Provider for the like post use case.
  ///
  /// Creates a [LikePostUseCase] for toggling post likes.
  LikePostUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likePostUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likePostUseCaseHash();

  @$internal
  @override
  $ProviderElement<LikePostUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LikePostUseCase create(Ref ref) {
    return likePostUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LikePostUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LikePostUseCase>(value),
    );
  }
}

String _$likePostUseCaseHash() => r'f0285919333fa863fd90083c609ab9dcc0d48606';
