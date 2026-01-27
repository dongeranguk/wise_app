// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 연락처 목록 컨트롤러

@ProviderFor(ContactsController)
const contactsControllerProvider = ContactsControllerProvider._();

/// 연락처 목록 컨트롤러
final class ContactsControllerProvider
    extends $AsyncNotifierProvider<ContactsController, List<Contact>> {
  /// 연락처 목록 컨트롤러
  const ContactsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsControllerHash();

  @$internal
  @override
  ContactsController create() => ContactsController();
}

String _$contactsControllerHash() =>
    r'6e4bc3e3134ef65e8382922fa6918c08802619a6';

/// 연락처 목록 컨트롤러

abstract class _$ContactsController extends $AsyncNotifier<List<Contact>> {
  FutureOr<List<Contact>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Contact>>, List<Contact>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Contact>>, List<Contact>>,
              AsyncValue<List<Contact>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 조직 목록 컨트롤러

@ProviderFor(OrganizationsController)
const organizationsControllerProvider = OrganizationsControllerProvider._();

/// 조직 목록 컨트롤러
final class OrganizationsControllerProvider
    extends
        $AsyncNotifierProvider<OrganizationsController, List<Organization>> {
  /// 조직 목록 컨트롤러
  const OrganizationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationsControllerHash();

  @$internal
  @override
  OrganizationsController create() => OrganizationsController();
}

String _$organizationsControllerHash() =>
    r'8fc2befe34b2362d1bfc0df7cea4ed266b41da2d';

/// 조직 목록 컨트롤러

abstract class _$OrganizationsController
    extends $AsyncNotifier<List<Organization>> {
  FutureOr<List<Organization>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Organization>>, List<Organization>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Organization>>, List<Organization>>,
              AsyncValue<List<Organization>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(FavoriteController)
const favoriteControllerProvider = FavoriteControllerProvider._();

final class FavoriteControllerProvider
    extends $AsyncNotifierProvider<FavoriteController, Set<String>> {
  const FavoriteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteControllerHash();

  @$internal
  @override
  FavoriteController create() => FavoriteController();
}

String _$favoriteControllerHash() =>
    r'4797dfd591a8006a8f0dcec3e700f4f3e77e0f6b';

abstract class _$FavoriteController extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
