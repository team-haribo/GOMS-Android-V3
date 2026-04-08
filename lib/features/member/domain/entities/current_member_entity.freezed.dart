// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_member_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurrentMemberEntity {
  int get memberId;
  String get email;
  String get name;
  RoleEnum get role;
  int get grade;
  DepartmentType get department;
  GenderType get gender;
  OutingStatusType get status;
  String get profileImageUrl;

  /// Create a copy of CurrentMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CurrentMemberEntityCopyWith<CurrentMemberEntity> get copyWith =>
      _$CurrentMemberEntityCopyWithImpl<CurrentMemberEntity>(
          this as CurrentMemberEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CurrentMemberEntity &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, email, name, role,
      grade, department, gender, status, profileImageUrl);

  @override
  String toString() {
    return 'CurrentMemberEntity(memberId: $memberId, email: $email, name: $name, role: $role, grade: $grade, department: $department, gender: $gender, status: $status, profileImageUrl: $profileImageUrl)';
  }
}

/// @nodoc
abstract mixin class $CurrentMemberEntityCopyWith<$Res> {
  factory $CurrentMemberEntityCopyWith(
          CurrentMemberEntity value, $Res Function(CurrentMemberEntity) _then) =
      _$CurrentMemberEntityCopyWithImpl;
  @useResult
  $Res call(
      {int memberId,
      String email,
      String name,
      RoleEnum role,
      int grade,
      DepartmentType department,
      GenderType gender,
      OutingStatusType status,
      String profileImageUrl});
}

/// @nodoc
class _$CurrentMemberEntityCopyWithImpl<$Res>
    implements $CurrentMemberEntityCopyWith<$Res> {
  _$CurrentMemberEntityCopyWithImpl(this._self, this._then);

  final CurrentMemberEntity _self;
  final $Res Function(CurrentMemberEntity) _then;

  /// Create a copy of CurrentMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? grade = null,
    Object? department = null,
    Object? gender = null,
    Object? status = null,
    Object? profileImageUrl = null,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleEnum,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentType,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OutingStatusType,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [CurrentMemberEntity].
extension CurrentMemberEntityPatterns on CurrentMemberEntity {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CurrentMemberEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CurrentMemberEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CurrentMemberEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int memberId,
            String email,
            String name,
            RoleEnum role,
            int grade,
            DepartmentType department,
            GenderType gender,
            OutingStatusType status,
            String profileImageUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity() when $default != null:
        return $default(
            _that.memberId,
            _that.email,
            _that.name,
            _that.role,
            _that.grade,
            _that.department,
            _that.gender,
            _that.status,
            _that.profileImageUrl);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int memberId,
            String email,
            String name,
            RoleEnum role,
            int grade,
            DepartmentType department,
            GenderType gender,
            OutingStatusType status,
            String profileImageUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity():
        return $default(
            _that.memberId,
            _that.email,
            _that.name,
            _that.role,
            _that.grade,
            _that.department,
            _that.gender,
            _that.status,
            _that.profileImageUrl);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int memberId,
            String email,
            String name,
            RoleEnum role,
            int grade,
            DepartmentType department,
            GenderType gender,
            OutingStatusType status,
            String profileImageUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentMemberEntity() when $default != null:
        return $default(
            _that.memberId,
            _that.email,
            _that.name,
            _that.role,
            _that.grade,
            _that.department,
            _that.gender,
            _that.status,
            _that.profileImageUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CurrentMemberEntity implements CurrentMemberEntity {
  const _CurrentMemberEntity(
      {required this.memberId,
      required this.email,
      required this.name,
      required this.role,
      this.grade = 0,
      this.department = DepartmentType.sw,
      this.gender = GenderType.male,
      this.status = OutingStatusType.coming,
      this.profileImageUrl = ''});

  @override
  final int memberId;
  @override
  final String email;
  @override
  final String name;
  @override
  final RoleEnum role;
  @override
  @JsonKey()
  final int grade;
  @override
  @JsonKey()
  final DepartmentType department;
  @override
  @JsonKey()
  final GenderType gender;
  @override
  @JsonKey()
  final OutingStatusType status;
  @override
  @JsonKey()
  final String profileImageUrl;

  /// Create a copy of CurrentMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CurrentMemberEntityCopyWith<_CurrentMemberEntity> get copyWith =>
      __$CurrentMemberEntityCopyWithImpl<_CurrentMemberEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CurrentMemberEntity &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, email, name, role,
      grade, department, gender, status, profileImageUrl);

  @override
  String toString() {
    return 'CurrentMemberEntity(memberId: $memberId, email: $email, name: $name, role: $role, grade: $grade, department: $department, gender: $gender, status: $status, profileImageUrl: $profileImageUrl)';
  }
}

/// @nodoc
abstract mixin class _$CurrentMemberEntityCopyWith<$Res>
    implements $CurrentMemberEntityCopyWith<$Res> {
  factory _$CurrentMemberEntityCopyWith(_CurrentMemberEntity value,
          $Res Function(_CurrentMemberEntity) _then) =
      __$CurrentMemberEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId,
      String email,
      String name,
      RoleEnum role,
      int grade,
      DepartmentType department,
      GenderType gender,
      OutingStatusType status,
      String profileImageUrl});
}

/// @nodoc
class __$CurrentMemberEntityCopyWithImpl<$Res>
    implements _$CurrentMemberEntityCopyWith<$Res> {
  __$CurrentMemberEntityCopyWithImpl(this._self, this._then);

  final _CurrentMemberEntity _self;
  final $Res Function(_CurrentMemberEntity) _then;

  /// Create a copy of CurrentMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? grade = null,
    Object? department = null,
    Object? gender = null,
    Object? status = null,
    Object? profileImageUrl = null,
  }) {
    return _then(_CurrentMemberEntity(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleEnum,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as DepartmentType,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OutingStatusType,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
