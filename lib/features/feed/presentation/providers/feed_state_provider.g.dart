// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async notifier for managing feed state and operations.
///
/// Handles loading posts, pagination, creating new posts,
/// and toggling likes with optimistic updates.

@ProviderFor(FeedNotifier)
final feedProvider = FeedNotifierProvider._();

/// Async notifier for managing feed state and operations.
///
/// Handles loading posts, pagination, creating new posts,
/// and toggling likes with optimistic updates.
final class FeedNotifierProvider
    extends $AsyncNotifierProvider<FeedNotifier, FeedState> {
  /// Async notifier for managing feed state and operations.
  ///
  /// Handles loading posts, pagination, creating new posts,
  /// and toggling likes with optimistic updates.
  FeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedNotifierHash();

  @$internal
  @override
  FeedNotifier create() => FeedNotifier();
}

String _$feedNotifierHash() => r'7c69fc1c1acee3c484e9e6314372c1b0c3b9bc32';

/// Async notifier for managing feed state and operations.
///
/// Handles loading posts, pagination, creating new posts,
/// and toggling likes with optimistic updates.

abstract class _$FeedNotifier extends $AsyncNotifier<FeedState> {
  FutureOr<FeedState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FeedState>, FeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FeedState>, FeedState>,
              AsyncValue<FeedState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
