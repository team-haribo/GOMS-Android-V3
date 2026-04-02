// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignUpRequestDto {
  String get email;
  String get verifiedToken;
  String get password;
  String get name;
  int get grade;
  DepartmentType get department;
  GenderType get gender;

  /// Create a copy of SignUpRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignUpRequestDtoCopyWith<SignUpRequestDto> get copyWith =>
      _$SignUpRequestDtoCopyWithImpl<SignUpRequestDto>(
          this as SignUpRequestDto, _$identity);

  /// Serializes this SignUpRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignUpRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, verifiedToken, password,
      name, grade, department, gender);

  @override
  String toString() {
    return 'SignUpRequestDto(email: $email, verifiedToken: $verifiedToken, password: $password, name: $name, grade: $grade, department: $department, gender: $gender)';
  }
}

/// @nodoc
abstract mixin class $SignUpRequestDtoCopyWith<$Res> {
  factory $SignUpRequestDtoCopyWith(
          SignUpRequestDto value, $Res Function(SignUpRequestDto) _then) =
      _$SignUpRequestDtoCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      String verifiedToken,
      String password,
      String name,
      int grade,
      DepartmentType department,
      GenderType gender});
}

/// @nodoc
class _$SignUpRequestDtoCopyWithImpl<$Res>
    implements $SignUpRequestDtoCopyWith<$Res> {
  _$SignUpRequestDtoCopyWithImpl(this._self, this._then);

  final SignUpRequestDto _self;
  final $Res Function(SignUpRequestDto) _then;

  /// Create a copy of SignUpRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? verifiedToken = null,
    Object? password = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? gender = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedToken: null == verifiedToken
          ? _self.verifiedToken
          : verifiedToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
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
              as DepartmentType,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType,
    ));
  }
}

/// Adds pattern-matching-related methods to [SignUpRequestDto].
extension SignUpRequestDtoPatterns on SignUpRequestDto {
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
    TResult Function(_SignUpRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto() when $default != null:
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
    TResult Function(_SignUpRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto():
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
    TResult? Function(_SignUpRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto() when $default != null:
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
            String email,
            String verifiedToken,
            String password,
            String name,
            int grade,
            DepartmentType department,
            GenderType gender)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto() when $default != null:
        return $default(_that.email, _that.verifiedToken, _that.password,
            _that.name, _that.grade, _that.department, _that.gender);
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
            String email,
            String verifiedToken,
            String password,
            String name,
            int grade,
            DepartmentType department,
            GenderType gender)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto():
        return $default(_that.email, _that.verifiedToken, _that.password,
            _that.name, _that.grade, _that.department, _that.gender);
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
            String email,
            String verifiedToken,
            String password,
            String name,
            int grade,
            DepartmentType department,
            GenderType gender)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignUpRequestDto() when $default != null:
        return $default(_that.email, _that.verifiedToken, _that.password,
            _that.name, _that.grade, _that.department, _that.gender);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SignUpRequestDto implements SignUpRequestDto {
  const _SignUpRequestDto(
      {required this.email,
      required this.verifiedToken,
      required this.password,
      required this.name,
      required this.grade,
      required this.department,
      required this.gender});
  factory _SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  @override
  final String email;
  @override
  final String verifiedToken;
  @override
  final String password;
  @override
  final String name;
  @override
  final int grade;
  @override
  final DepartmentType department;
  @override
  final GenderType gender;

  /// Create a copy of SignUpRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SignUpRequestDtoCopyWith<_SignUpRequestDto> get copyWith =>
      __$SignUpRequestDtoCopyWithImpl<_SignUpRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SignUpRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignUpRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, verifiedToken, password,
      name, grade, department, gender);

  @override
  String toString() {
    return 'SignUpRequestDto(email: $email, verifiedToken: $verifiedToken, password: $password, name: $name, grade: $grade, department: $department, gender: $gender)';
  }
}

/// @nodoc
abstract mixin class _$SignUpRequestDtoCopyWith<$Res>
    implements $SignUpRequestDtoCopyWith<$Res> {
  factory _$SignUpRequestDtoCopyWith(
          _SignUpRequestDto value, $Res Function(_SignUpRequestDto) _then) =
      __$SignUpRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String email,
      String verifiedToken,
      String password,
      String name,
      int grade,
      DepartmentType department,
      GenderType gender});
}

/// @nodoc
class __$SignUpRequestDtoCopyWithImpl<$Res>
    implements _$SignUpRequestDtoCopyWith<$Res> {
  __$SignUpRequestDtoCopyWithImpl(this._self, this._then);

  final _SignUpRequestDto _self;
  final $Res Function(_SignUpRequestDto) _then;

  /// Create a copy of SignUpRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? verifiedToken = null,
    Object? password = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? gender = null,
  }) {
    return _then(_SignUpRequestDto(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedToken: null == verifiedToken
          ? _self.verifiedToken
          : verifiedToken // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
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
              as DepartmentType,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType,
    ));
  }
}

// dart format on
