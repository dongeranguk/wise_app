import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts_model.freezed.dart';
part 'contacts_model.g.dart';

@freezed
abstract class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    @JsonKey(name: 'parent_id') String? parentId,
    @Default(0) int level,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String email,
    String? username,
    String? position,
    String? department,
    @JsonKey(name: 'organization_id') String? organizationId,
    @JsonKey(name: 'mobile_phone') String? mobilePhone,
    @JsonKey(name: 'office_phone') String? officePhone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'work_location') String? workLocation,
    @JsonKey(name: 'work_role') String? workRole,
    @Default('offline') String status,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

@freezed
abstract class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'contact_id') required String contactId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}
