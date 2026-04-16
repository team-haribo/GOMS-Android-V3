// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignupState {
  SignupStatus get status;
  String get name;
  String get email;
  String get grade;
  String get password;
  String get passwordConfirm;
  GenderType? get gender;
  DepartmentType? get major;
  String? get nameError;
  String? get emailError;
  String? get gradeError;
  String? get passwordError;
  String? get passwordConfirmError;
  String? get errorMessage;

  /// Create a copy of SignupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignupStateCopyWith<SignupState> get copyWith =>
      _$SignupStateCopyWithImpl<SignupState>(this as SignupState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignupState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.gradeError, gradeError) ||
                other.gradeError == gradeError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.passwordConfirmError, passwordConfirmError) ||
                other.passwordConfirmError == passwordConfirmError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      name,
      email,
      grade,
      password,
      passwordConfirm,
      gender,
      major,
      nameError,
      emailError,
      gradeError,
      passwordError,
      passwordConfirmError,
      errorMessage);

  @override
  String toString() {
    return 'SignupState(status: $status, name: $name, email: $email, grade: $grade, password: $password, passwordConfirm: $passwordConfirm, gender: $gender, major: $major, nameError: $nameError, emailError: $emailError, gradeError: $gradeError, passwordError: $passwordError, passwordConfirmError: $passwordConfirmError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $SignupStateCopyWith<$Res> {
  factory $SignupStateCopyWith(
          SignupState value, $Res Function(SignupState) _then) =
      _$SignupStateCopyWithImpl;
  @useResult
  $Res call(
      {SignupStatus status,
      String name,
      String email,
      String grade,
      String password,
      String passwordConfirm,
      GenderType? gender,
      DepartmentType? major,
      String? nameError,
      String? emailError,
      String? gradeError,
      String? passwordError,
      String? passwordConfirmError,
      String? errorMessage});
}

/// @nodoc
class _$SignupStateCopyWithImpl<$Res> implements $SignupStateCopyWith<$Res> {
  _$SignupStateCopyWithImpl(this._self, this._then);

  final SignupState _self;
  final $Res Function(SignupState) _then;

  /// Create a copy of SignupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? name = null,
    Object? email = null,
    Object? grade = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? gender = freezed,
    Object? major = freezed,
    Object? nameError = freezed,
    Object? emailError = freezed,
    Object? gradeError = freezed,
    Object? passwordError = freezed,
    Object? passwordConfirmError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SignupStatus,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _self.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType?,
      major: freezed == major
          ? _self.major
          : major // ignore: cast_nullable_to_non_nullable
              as DepartmentType?,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeError: freezed == gradeError
          ? _self.gradeError
          : gradeError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordConfirmError: freezed == passwordConfirmError
          ? _self.passwordConfirmError
          : passwordConfirmError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SignupState].
extension SignupStatePatterns on SignupState {
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
    TResult Function(_SignupState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignupState() when $default != null:
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
    TResult Function(_SignupState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignupState():
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
    TResult? Function(_SignupState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignupState() when $default != null:
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
            SignupStatus status,
            String name,
            String email,
            String grade,
            String password,
            String passwordConfirm,
            GenderType? gender,
            DepartmentType? major,
            String? nameError,
            String? emailError,
            String? gradeError,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignupState() when $default != null:
        return $default(
            _that.status,
            _that.name,
            _that.email,
            _that.grade,
            _that.password,
            _that.passwordConfirm,
            _that.gender,
            _that.major,
            _that.nameError,
            _that.emailError,
            _that.gradeError,
            _that.passwordError,
            _that.passwordConfirmError,
            _that.errorMessage);
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
            SignupStatus status,
            String name,
            String email,
            String grade,
            String password,
            String passwordConfirm,
            GenderType? gender,
            DepartmentType? major,
            String? nameError,
            String? emailError,
            String? gradeError,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignupState():
        return $default(
            _that.status,
            _that.name,
            _that.email,
            _that.grade,
            _that.password,
            _that.passwordConfirm,
            _that.gender,
            _that.major,
            _that.nameError,
            _that.emailError,
            _that.gradeError,
            _that.passwordError,
            _that.passwordConfirmError,
            _that.errorMessage);
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
            SignupStatus status,
            String name,
            String email,
            String grade,
            String password,
            String passwordConfirm,
            GenderType? gender,
            DepartmentType? major,
            String? nameError,
            String? emailError,
            String? gradeError,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignupState() when $default != null:
        return $default(
            _that.status,
            _that.name,
            _that.email,
            _that.grade,
            _that.password,
            _that.passwordConfirm,
            _that.gender,
            _that.major,
            _that.nameError,
            _that.emailError,
            _that.gradeError,
            _that.passwordError,
            _that.passwordConfirmError,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SignupState implements SignupState {
  const _SignupState(
      {this.status = SignupStatus.initial,
      this.name = '',
      this.email = '',
      this.grade = '',
      this.password = '',
      this.passwordConfirm = '',
      this.gender,
      this.major,
      this.nameError,
      this.emailError,
      this.gradeError,
      this.passwordError,
      this.passwordConfirmError,
      this.errorMessage});

  @override
  @JsonKey()
  final SignupStatus status;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String grade;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String passwordConfirm;
  @override
  final GenderType? gender;
  @override
  final DepartmentType? major;
  @override
  final String? nameError;
  @override
  final String? emailError;
  @override
  final String? gradeError;
  @override
  final String? passwordError;
  @override
  final String? passwordConfirmError;
  @override
  final String? errorMessage;

  /// Create a copy of SignupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SignupStateCopyWith<_SignupState> get copyWith =>
      __$SignupStateCopyWithImpl<_SignupState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignupState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.gradeError, gradeError) ||
                other.gradeError == gradeError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.passwordConfirmError, passwordConfirmError) ||
                other.passwordConfirmError == passwordConfirmError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      name,
      email,
      grade,
      password,
      passwordConfirm,
      gender,
      major,
      nameError,
      emailError,
      gradeError,
      passwordError,
      passwordConfirmError,
      errorMessage);

  @override
  String toString() {
    return 'SignupState(status: $status, name: $name, email: $email, grade: $grade, password: $password, passwordConfirm: $passwordConfirm, gender: $gender, major: $major, nameError: $nameError, emailError: $emailError, gradeError: $gradeError, passwordError: $passwordError, passwordConfirmError: $passwordConfirmError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$SignupStateCopyWith<$Res>
    implements $SignupStateCopyWith<$Res> {
  factory _$SignupStateCopyWith(
          _SignupState value, $Res Function(_SignupState) _then) =
      __$SignupStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SignupStatus status,
      String name,
      String email,
      String grade,
      String password,
      String passwordConfirm,
      GenderType? gender,
      DepartmentType? major,
      String? nameError,
      String? emailError,
      String? gradeError,
      String? passwordError,
      String? passwordConfirmError,
      String? errorMessage});
}

/// @nodoc
class __$SignupStateCopyWithImpl<$Res> implements _$SignupStateCopyWith<$Res> {
  __$SignupStateCopyWithImpl(this._self, this._then);

  final _SignupState _self;
  final $Res Function(_SignupState) _then;

  /// Create a copy of SignupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? name = null,
    Object? email = null,
    Object? grade = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? gender = freezed,
    Object? major = freezed,
    Object? nameError = freezed,
    Object? emailError = freezed,
    Object? gradeError = freezed,
    Object? passwordError = freezed,
    Object? passwordConfirmError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_SignupState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SignupStatus,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _self.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as GenderType?,
      major: freezed == major
          ? _self.major
          : major // ignore: cast_nullable_to_non_nullable
              as DepartmentType?,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeError: freezed == gradeError
          ? _self.gradeError
          : gradeError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordConfirmError: freezed == passwordConfirmError
          ? _self.passwordConfirmError
          : passwordConfirmError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
