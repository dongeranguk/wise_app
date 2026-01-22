// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 아바타 업로드 로딩 상태 관리

@ProviderFor(IsUploadingAvatar)
const isUploadingAvatarProvider = IsUploadingAvatarProvider._();

/// 아바타 업로드 로딩 상태 관리
final class IsUploadingAvatarProvider
    extends $NotifierProvider<IsUploadingAvatar, bool> {
  /// 아바타 업로드 로딩 상태 관리
  const IsUploadingAvatarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isUploadingAvatarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isUploadingAvatarHash();

  @$internal
  @override
  IsUploadingAvatar create() => IsUploadingAvatar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isUploadingAvatarHash() => r'0fe2ab2001240708ebb4b2bc8010971597702a8a';

/// 아바타 업로드 로딩 상태 관리

abstract class _$IsUploadingAvatar extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerFamily._();

final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, Profile> {
  const ProfileControllerProvider._({
    required ProfileControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profileControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @override
  String toString() {
    return r'profileControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileController create() => ProfileController();

  @override
  bool operator ==(Object other) {
    return other is ProfileControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileControllerHash() => r'4fdcb1773024952ab98adc28359ed52a4bda3ca7';

final class ProfileControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileController,
          AsyncValue<Profile>,
          Profile,
          FutureOr<Profile>,
          String
        > {
  const ProfileControllerFamily._()
    : super(
        retry: null,
        name: r'profileControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileControllerProvider call(String userId) =>
      ProfileControllerProvider._(argument: userId, from: this);

  @override
  String toString() => r'profileControllerProvider';
}

abstract class _$ProfileController extends $AsyncNotifier<Profile> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<Profile> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Profile>, Profile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile>, Profile>,
              AsyncValue<Profile>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
