import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wise_app/features/profile/profile_model.dart';
import 'package:wise_app/features/profile/profile_repository.dart';

part 'profile_controller.g.dart';

/// 아바타 업로드 로딩 상태 관리
@riverpod
class IsUploadingAvatar extends _$IsUploadingAvatar {
  @override
  bool build() => false;

  void setUploading(bool value) => state = value;
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<Profile> build(String userId) async {
    // userId에 해당하는 프로필을 로드하여 반환
    return await ref.read(profileRepositoryProvider).getProfile(userId: userId);
  }

  // 프로필 새로고침이 필요할 때 호출
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> updateProfile({required Profile profile}) async {
    await ref.read(profileRepositoryProvider).updateProfile(profile: profile);
    ref.invalidateSelf();
  }

  Future<void> pickAndUploadImage() async {
    if (!state.hasValue) return;

    final currentProfile = state.value!;
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 로딩 시작
      ref.read(isUploadingAvatarProvider.notifier).setUploading(true);

      try {
        final bytes = await image.readAsBytes();
        final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final avatarUrl = await ref
            .read(profileRepositoryProvider)
            .uploadAvatar(
              userId: currentProfile.id,
              imageBytes: bytes,
              fileName: fileName,
            );

        final updatedProfile = currentProfile.copyWith(avatarUrl: avatarUrl);
        await updateProfile(profile: updatedProfile);
      } finally {
        // 로딩 종료 (성공/실패 모두)
        ref.read(isUploadingAvatarProvider.notifier).setUploading(false);
      }
    }
  }
}
