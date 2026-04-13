// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_council_student_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentCouncilStudentEntity {
  int get memberId;
  String get name;
  int get grade;
  String get department;
  StudentRole get studentRole;
  String get profileImageUrl;
  String get role;
  String get status;

  /// Create a copy of StudentCouncilStudentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StudentCouncilStudentEntityCopyWith<StudentCouncilStudentEntity>
      get copyWith => _$StudentCouncilStudentEntityCopyWithImpl<
              StudentCouncilStudentEntity>(
          this as StudentCouncilStudentEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StudentCouncilStudentEntity &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.studentRole, studentRole) ||
                other.studentRole == studentRole) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, name, grade,
      department, studentRole, profileImageUrl, role, status);

  @override
  String toString() {
    return 'StudentCouncilStudentEntity(memberId: $memberId, name: $name, grade: $grade, department: $department, studentRole: $studentRole, profileImageUrl: $profileImageUrl, role: $role, status: $status)';
  }
}

/// @nodoc
abstract mixin class $StudentCouncilStudentEntityCopyWith<$Res> {
  factory $StudentCouncilStudentEntityCopyWith(
          StudentCouncilStudentEntity value,
          $Res Function(StudentCouncilStudentEntity) _then) =
      _$StudentCouncilStudentEntityCopyWithImpl;
  @useResult
  $Res call(
      {int memberId,
      String name,
      int grade,
      String department,
      StudentRole studentRole,
      String profileImageUrl,
      String role,
      String status});
}

/// @nodoc
class _$StudentCouncilStudentEntityCopyWithImpl<$Res>
    implements $StudentCouncilStudentEntityCopyWith<$Res> {
  _$StudentCouncilStudentEntityCopyWithImpl(this._self, this._then);

  final StudentCouncilStudentEntity _self;
  final $Res Function(StudentCouncilStudentEntity) _then;

  /// Create a copy of StudentCouncilStudentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? studentRole = null,
    Object? profileImageUrl = null,
    Object? role = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      studentRole: null == studentRole
          ? _self.studentRole
          : studentRole // ignore: cast_nullable_to_non_nullable
              as StudentRole,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [StudentCouncilStudentEntity].
extension StudentCouncilStudentEntityPatterns on StudentCouncilStudentEntity {
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
    TResult Function(_StudentCouncilStudentEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity() when $default != null:
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
    TResult Function(_StudentCouncilStudentEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity():
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
    TResult? Function(_StudentCouncilStudentEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity() when $default != null:
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
            String name,
            int grade,
            String department,
            StudentRole studentRole,
            String profileImageUrl,
            String role,
            String status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity() when $default != null:
        return $default(
            _that.memberId,
            _that.name,
            _that.grade,
            _that.department,
            _that.studentRole,
            _that.profileImageUrl,
            _that.role,
            _that.status);
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
            String name,
            int grade,
            String department,
            StudentRole studentRole,
            String profileImageUrl,
            String role,
            String status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity():
        return $default(
            _that.memberId,
            _that.name,
            _that.grade,
            _that.department,
            _that.studentRole,
            _that.profileImageUrl,
            _that.role,
            _that.status);
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
            String name,
            int grade,
            String department,
            StudentRole studentRole,
            String profileImageUrl,
            String role,
            String status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StudentCouncilStudentEntity() when $default != null:
        return $default(
            _that.memberId,
            _that.name,
            _that.grade,
            _that.department,
            _that.studentRole,
            _that.profileImageUrl,
            _that.role,
            _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StudentCouncilStudentEntity implements StudentCouncilStudentEntity {
  const _StudentCouncilStudentEntity(
      {required this.memberId,
      required this.name,
      required this.grade,
      required this.department,
      required this.studentRole,
      this.profileImageUrl = '',
      this.role = '',
      this.status = ''});

  @override
  final int memberId;
  @override
  final String name;
  @override
  final int grade;
  @override
  final String department;
  @override
  final StudentRole studentRole;
  @override
  @JsonKey()
  final String profileImageUrl;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final String status;

  /// Create a copy of StudentCouncilStudentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StudentCouncilStudentEntityCopyWith<_StudentCouncilStudentEntity>
      get copyWith => __$StudentCouncilStudentEntityCopyWithImpl<
          _StudentCouncilStudentEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StudentCouncilStudentEntity &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.studentRole, studentRole) ||
                other.studentRole == studentRole) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberId, name, grade,
      department, studentRole, profileImageUrl, role, status);

  @override
  String toString() {
    return 'StudentCouncilStudentEntity(memberId: $memberId, name: $name, grade: $grade, department: $department, studentRole: $studentRole, profileImageUrl: $profileImageUrl, role: $role, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$StudentCouncilStudentEntityCopyWith<$Res>
    implements $StudentCouncilStudentEntityCopyWith<$Res> {
  factory _$StudentCouncilStudentEntityCopyWith(
          _StudentCouncilStudentEntity value,
          $Res Function(_StudentCouncilStudentEntity) _then) =
      __$StudentCouncilStudentEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId,
      String name,
      int grade,
      String department,
      StudentRole studentRole,
      String profileImageUrl,
      String role,
      String status});
}

/// @nodoc
class __$StudentCouncilStudentEntityCopyWithImpl<$Res>
    implements _$StudentCouncilStudentEntityCopyWith<$Res> {
  __$StudentCouncilStudentEntityCopyWithImpl(this._self, this._then);

  final _StudentCouncilStudentEntity _self;
  final $Res Function(_StudentCouncilStudentEntity) _then;

  /// Create a copy of StudentCouncilStudentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? studentRole = null,
    Object? profileImageUrl = null,
    Object? role = null,
    Object? status = null,
  }) {
    return _then(_StudentCouncilStudentEntity(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      studentRole: null == studentRole
          ? _self.studentRole
          : studentRole // ignore: cast_nullable_to_non_nullable
              as StudentRole,
      profileImageUrl: null == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
