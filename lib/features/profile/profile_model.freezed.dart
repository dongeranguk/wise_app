// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get email; String? get username; String? get position; String? get department; String get role;@JsonKey(name: 'work_location') String? get workLocation;@JsonKey(name: 'work_role') String? get workRole;@JsonKey(name: 'mobile_phone') String? get mobilePhone;@JsonKey(name: 'office_phone') String? get officePhone;@JsonKey(name: 'avatar_url') String? get avatarUrl;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.position, position) || other.position == position)&&(identical(other.department, department) || other.department == department)&&(identical(other.role, role) || other.role == role)&&(identical(other.workLocation, workLocation) || other.workLocation == workLocation)&&(identical(other.workRole, workRole) || other.workRole == workRole)&&(identical(other.mobilePhone, mobilePhone) || other.mobilePhone == mobilePhone)&&(identical(other.officePhone, officePhone) || other.officePhone == officePhone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,position,department,role,workLocation,workRole,mobilePhone,officePhone,avatarUrl);

@override
String toString() {
  return 'Profile(id: $id, email: $email, username: $username, position: $position, department: $department, role: $role, workLocation: $workLocation, workRole: $workRole, mobilePhone: $mobilePhone, officePhone: $officePhone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? username, String? position, String? department, String role,@JsonKey(name: 'work_location') String? workLocation,@JsonKey(name: 'work_role') String? workRole,@JsonKey(name: 'mobile_phone') String? mobilePhone,@JsonKey(name: 'office_phone') String? officePhone,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? position = freezed,Object? department = freezed,Object? role = null,Object? workLocation = freezed,Object? workRole = freezed,Object? mobilePhone = freezed,Object? officePhone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,workLocation: freezed == workLocation ? _self.workLocation : workLocation // ignore: cast_nullable_to_non_nullable
as String?,workRole: freezed == workRole ? _self.workRole : workRole // ignore: cast_nullable_to_non_nullable
as String?,mobilePhone: freezed == mobilePhone ? _self.mobilePhone : mobilePhone // ignore: cast_nullable_to_non_nullable
as String?,officePhone: freezed == officePhone ? _self.officePhone : officePhone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? username,  String? position,  String? department,  String role, @JsonKey(name: 'work_location')  String? workLocation, @JsonKey(name: 'work_role')  String? workRole, @JsonKey(name: 'mobile_phone')  String? mobilePhone, @JsonKey(name: 'office_phone')  String? officePhone, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.position,_that.department,_that.role,_that.workLocation,_that.workRole,_that.mobilePhone,_that.officePhone,_that.avatarUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? username,  String? position,  String? department,  String role, @JsonKey(name: 'work_location')  String? workLocation, @JsonKey(name: 'work_role')  String? workRole, @JsonKey(name: 'mobile_phone')  String? mobilePhone, @JsonKey(name: 'office_phone')  String? officePhone, @JsonKey(name: 'avatar_url')  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.email,_that.username,_that.position,_that.department,_that.role,_that.workLocation,_that.workRole,_that.mobilePhone,_that.officePhone,_that.avatarUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? username,  String? position,  String? department,  String role, @JsonKey(name: 'work_location')  String? workLocation, @JsonKey(name: 'work_role')  String? workRole, @JsonKey(name: 'mobile_phone')  String? mobilePhone, @JsonKey(name: 'office_phone')  String? officePhone, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.position,_that.department,_that.role,_that.workLocation,_that.workRole,_that.mobilePhone,_that.officePhone,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.email, this.username, this.position, this.department, this.role = 'member', @JsonKey(name: 'work_location') this.workLocation, @JsonKey(name: 'work_role') this.workRole, @JsonKey(name: 'mobile_phone') this.mobilePhone, @JsonKey(name: 'office_phone') this.officePhone, @JsonKey(name: 'avatar_url') this.avatarUrl});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? username;
@override final  String? position;
@override final  String? department;
@override@JsonKey() final  String role;
@override@JsonKey(name: 'work_location') final  String? workLocation;
@override@JsonKey(name: 'work_role') final  String? workRole;
@override@JsonKey(name: 'mobile_phone') final  String? mobilePhone;
@override@JsonKey(name: 'office_phone') final  String? officePhone;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.position, position) || other.position == position)&&(identical(other.department, department) || other.department == department)&&(identical(other.role, role) || other.role == role)&&(identical(other.workLocation, workLocation) || other.workLocation == workLocation)&&(identical(other.workRole, workRole) || other.workRole == workRole)&&(identical(other.mobilePhone, mobilePhone) || other.mobilePhone == mobilePhone)&&(identical(other.officePhone, officePhone) || other.officePhone == officePhone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,position,department,role,workLocation,workRole,mobilePhone,officePhone,avatarUrl);

@override
String toString() {
  return 'Profile(id: $id, email: $email, username: $username, position: $position, department: $department, role: $role, workLocation: $workLocation, workRole: $workRole, mobilePhone: $mobilePhone, officePhone: $officePhone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? username, String? position, String? department, String role,@JsonKey(name: 'work_location') String? workLocation,@JsonKey(name: 'work_role') String? workRole,@JsonKey(name: 'mobile_phone') String? mobilePhone,@JsonKey(name: 'office_phone') String? officePhone,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? position = freezed,Object? department = freezed,Object? role = null,Object? workLocation = freezed,Object? workRole = freezed,Object? mobilePhone = freezed,Object? officePhone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,workLocation: freezed == workLocation ? _self.workLocation : workLocation // ignore: cast_nullable_to_non_nullable
as String?,workRole: freezed == workRole ? _self.workRole : workRole // ignore: cast_nullable_to_non_nullable
as String?,mobilePhone: freezed == mobilePhone ? _self.mobilePhone : mobilePhone // ignore: cast_nullable_to_non_nullable
as String?,officePhone: freezed == officePhone ? _self.officePhone : officePhone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
