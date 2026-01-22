import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wise_app/features/profile/profile_controller.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  late TextEditingController _workLocationController;
  late TextEditingController _workRoleController;
  late TextEditingController _mobilePhoneController;
  late TextEditingController _officePhoneController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider(widget.userId)).value;
    _usernameController = TextEditingController(text: profile?.username);
    _positionController = TextEditingController(text: profile?.position);
    _departmentController = TextEditingController(text: profile?.department);
    _workLocationController = TextEditingController(
      text: profile?.workLocation,
    );
    _workRoleController = TextEditingController(text: profile?.workRole);
    _mobilePhoneController = TextEditingController(text: profile?.mobilePhone);
    _officePhoneController = TextEditingController(text: profile?.officePhone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _workLocationController.dispose();
    _workRoleController.dispose();
    _mobilePhoneController.dispose();
    _officePhoneController.dispose();
    super.dispose();
  }

  // 빈 문자열을 null로 변환하는 헬퍼 함수
  String? _emptyToNull(String text) => text.trim().isEmpty ? null : text.trim();

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final currentProfile = ref
        .read(profileControllerProvider(widget.userId))
        .value;
    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      username: _emptyToNull(_usernameController.text),
      position: _emptyToNull(_positionController.text),
      department: _emptyToNull(_departmentController.text),
      workLocation: _emptyToNull(_workLocationController.text),
      workRole: _emptyToNull(_workRoleController.text),
      mobilePhone: _emptyToNull(_mobilePhoneController.text),
      officePhone: _emptyToNull(_officePhoneController.text),
    );

    if (currentProfile == updatedProfile) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    try {
      await ref
          .read(profileControllerProvider(widget.userId).notifier)
          .updateProfile(profile: updatedProfile);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필이 업데이트되었습니다.')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업데이트 실패: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기본 정보',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '이름을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: '직책',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: '부서',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '추가 정보',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workLocationController,
                decoration: const InputDecoration(
                  labelText: '파견 근무처',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workRoleController,
                decoration: const InputDecoration(
                  labelText: '담당 업무',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '연락처',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobilePhoneController,
                decoration: const InputDecoration(
                  labelText: '휴대폰 번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _officePhoneController,
                decoration: const InputDecoration(
                  labelText: '사내 번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
