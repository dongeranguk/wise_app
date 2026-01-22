import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wise_app/features/profile/profile_model.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepository(Supabase.instance.client);

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  // 프로필 조회 - 로그인 상태에서만 호출되므로 프로필이 반드시 존재해야 함
  Future<Profile> getProfile({required String userId}) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return Profile.fromJson(response);
    } on PostgrestException catch (e) {
      // Supabase DB 에러 (프로필 없음, 쿼리 에러 등)
      throw Exception('프로필 조회 실패: ${e.message}');
    } catch (e) {
      // 네트워크 에러 등 기타 예외
      throw Exception('프로필 조회 중 오류 발생: $e');
    }
  }

  Future<void> updateProfile({required Profile profile}) async {
    try {
      await _client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } on PostgrestException catch (e) {
      // Supabase DB 에러 (프로필 없음, 쿼리 에러 등)
      throw Exception('프로필 업데이트 실패: ${e.message}');
    } catch (e) {
      // 네트워크 에러 등 기타 예외
      throw Exception('프로필 업데이트 중 오류 발생: $e');
    }
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      final path = '$userId/$fileName';

      await _client.storage
          .from('avatars')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: FileOptions(upsert: true),
          );

      final signedUrl = await _client.storage
          .from('avatars')
          .createSignedUrl(path, 60 * 60 * 24 * 365);

      return signedUrl;
    } on StorageException catch (e) {
      throw Exception('이미지 업로드 실패 : ${e.message}');
    } catch (e) {
      throw Exception('이미지 업로드 중 오류 발생 : $e');
    }
  }
}
