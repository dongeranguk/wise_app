import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wise_app/features/contacts/contacts_model.dart';
import 'package:wise_app/features/contacts/contacts_repository.dart';

part 'contacts_controller.g.dart';

/// 연락처 목록 컨트롤러
@riverpod
class ContactsController extends _$ContactsController {
  @override
  FutureOr<List<Contact>> build() async {
    return await ref.read(contactsRepositoryProvider).getContacts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(contactsRepositoryProvider).getContacts(),
    );
  }
}

/// 조직 목록 컨트롤러
@riverpod
class OrganizationsController extends _$OrganizationsController {
  @override
  FutureOr<List<Organization>> build() async {
    return await ref.read(contactsRepositoryProvider).getOrganizations();
  }
}

@riverpod
class FavoriteController extends _$FavoriteController {
  @override
  FutureOr<Set<String>> build() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return {};

    final favorites = await ref
        .read(contactsRepositoryProvider)
        .getFavorites(userId);

    return favorites.map((favorite) => favorite.contactId).toSet();
  }

  Future<void> toggleFavorite(String contactId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final currentFavorites = state.value ?? {};
    if (currentFavorites.contains(contactId)) {
      await ref
          .read(contactsRepositoryProvider)
          .removeFavorite(userId, contactId);
    } else {
      await ref.read(contactsRepositoryProvider).addFavorite(userId, contactId);
    }

    ref.invalidateSelf();
  }
}
