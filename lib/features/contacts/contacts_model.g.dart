// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organization _$OrganizationFromJson(Map<String, dynamic> json) =>
    _Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      level: (json['level'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$OrganizationToJson(_Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
      'level': instance.level,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String?,
  position: json['position'] as String?,
  department: json['department'] as String?,
  organizationId: json['organization_id'] as String?,
  mobilePhone: json['mobile_phone'] as String?,
  officePhone: json['office_phone'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  workLocation: json['work_location'] as String?,
  workRole: json['work_role'] as String?,
  status: json['status'] as String? ?? 'offline',
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'position': instance.position,
  'department': instance.department,
  'organization_id': instance.organizationId,
  'mobile_phone': instance.mobilePhone,
  'office_phone': instance.officePhone,
  'avatar_url': instance.avatarUrl,
  'work_location': instance.workLocation,
  'work_role': instance.workRole,
  'status': instance.status,
};

_Favorite _$FavoriteFromJson(Map<String, dynamic> json) => _Favorite(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  contactId: json['contact_id'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$FavoriteToJson(_Favorite instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'contact_id': instance.contactId,
  'created_at': instance.createdAt?.toIso8601String(),
};
