import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wise_app/features/profile/profile_controller.dart';
import 'package:wise_app/features/profile/profile_model.dart';

class ProfileContent extends ConsumerWidget {
  const ProfileContent({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider(userId));

    // 에러 발생 시 SnackBar 표시
    ref.listen(profileControllerProvider(userId), (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('프로필 조회 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit/$userId'),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => _ProfileContent(profile: profile),
        error: (error, _) => _ErrorView(
          message: '프로필을 불러올 수 없습니다',
          onRetry: () => ref.invalidate(profileControllerProvider(userId)),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// 프로필 정보 표시 위젯
class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.watch(isUploadingAvatarProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // 프로필 아바타
          GestureDetector(
            onTap: isUploading
                ? null // 업로드 중에는 클릭 비활성화
                : () async {
                    await ref
                        .read(profileControllerProvider(profile.id).notifier)
                        .pickAndUploadImage();
                  },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: profile.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profile.avatarUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Text(
                              profile.username?.substring(0, 1).toUpperCase() ??
                                  profile.email.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          profile.username?.substring(0, 1).toUpperCase() ??
                              profile.email.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                // 로딩 오버레이
                if (isUploading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                // 카메라 아이콘
                if (!isUploading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 이름
          Text(
            profile.username ?? '이름 없음',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // 역할 뱃지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: profile.role == 'admin'
                  ? Colors.orange.shade100
                  : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              profile.role == 'admin' ? '관리자' : '멤버',
              style: TextStyle(
                color: profile.role == 'admin'
                    ? Colors.orange.shade800
                    : Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 정보 카드
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.email,
                    label: '이메일',
                    value: profile.email,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.work,
                    label: '직책',
                    value: profile.position ?? '미설정',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.business,
                    label: '부서',
                    value: profile.department ?? '미설정',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.location_on,
                    label: '파견 근무처',
                    value: profile.workLocation ?? '미설정',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.assignment,
                    label: '담당 업무',
                    value: profile.workRole ?? '미설정',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.phone_android,
                    label: '휴대폰 번호',
                    value: profile.mobilePhone ?? '미설정',
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.phone,
                    label: '사내 번호',
                    value: profile.officePhone ?? '미설정',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 정보 행 위젯
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}

// 에러 화면 위젯
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
