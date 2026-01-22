import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String email,
    String? username,
    String? position,
    String? department,
    @Default('member') String role,
    @JsonKey(name: 'work_location') String? workLocation,
    @JsonKey(name: 'work_role') String? workRole,
    @JsonKey(name: 'mobile_phone') String? mobilePhone,
    @JsonKey(name: 'office_phone') String? officePhone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
