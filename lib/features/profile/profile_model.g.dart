// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  position: json['position'] as String?,
  department: json['department'] as String?,
  role: json['role'] as String? ?? 'member',
  workLocation: json['work_location'] as String?,
  workRole: json['work_role'] as String?,
  mobilePhone: json['mobile_phone'] as String?,
  officePhone: json['office_phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'position': instance.position,
  'department': instance.department,
  'role': instance.role,
  'work_location': instance.workLocation,
  'work_role': instance.workRole,
  'mobile_phone': instance.mobilePhone,
  'office_phone': instance.officePhone,
  'avatar_url': instance.avatarUrl,
};
