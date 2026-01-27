import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wise_app/features/contacts/contacts_model.dart';

part 'contacts_repository.g.dart';

@riverpod
ContactsRepository contactsRepository(Ref ref) =>
    ContactsRepository(Supabase.instance.client);

class ContactsRepository {
  final SupabaseClient _client;

  ContactsRepository(this._client);

  Future<List<Organization>> getOrganizations() async {
    final response = await _client
        .from('organizations')
        .select()
        .eq('is_active', true)
        .order('level')
        .order('sort_order');

    return (response as List)
        .map((json) => Organization.fromJson(json))
        .toList();
  }

  Future<List<Contact>> getContacts() async {
    final response = await _client.from('profiles').select();

    return (response as List).map((json) => Contact.fromJson(json)).toList();
  }

  Future<List<Contact>> getContactsByOrganizationId(
    String organizationId,
  ) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('organization_id', organizationId);

    return (response as List).map((json) => Contact.fromJson(json)).toList();
  }

  Future<Set<Favorite>> getFavorites(String userId) async {
    final response = await _client
        .from('favorites')
        .select()
        .eq('user_id', userId);

    return (response as List).map((json) => Favorite.fromJson(json)).toSet();
  }

  Future<void> addFavorite(String userId, String contactId) async {
    await _client.from('favorites').insert({
      'user_id': userId,
      'contact_id': contactId,
    });
  }

  Future<void> removeFavorite(String userId, String contactId) async {
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('contact_id', contactId);
  }
}
