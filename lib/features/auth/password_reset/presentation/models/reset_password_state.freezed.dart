// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResetPasswordState {
  ResetPasswordStatus get status;
  String get password;
  String get passwordConfirm;
  String? get passwordError;
  String? get passwordConfirmError;
  String? get errorMessage;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResetPasswordStateCopyWith<ResetPasswordState> get copyWith =>
      _$ResetPasswordStateCopyWithImpl<ResetPasswordState>(
          this as ResetPasswordState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResetPasswordState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.passwordConfirmError, passwordConfirmError) ||
                other.passwordConfirmError == passwordConfirmError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, password,
      passwordConfirm, passwordError, passwordConfirmError, errorMessage);

  @override
  String toString() {
    return 'ResetPasswordState(status: $status, password: $password, passwordConfirm: $passwordConfirm, passwordError: $passwordError, passwordConfirmError: $passwordConfirmError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordStateCopyWith(
          ResetPasswordState value, $Res Function(ResetPasswordState) _then) =
      _$ResetPasswordStateCopyWithImpl;
  @useResult
  $Res call(
      {ResetPasswordStatus status,
      String password,
      String passwordConfirm,
      String? passwordError,
      String? passwordConfirmError,
      String? errorMessage});
}

/// @nodoc
class _$ResetPasswordStateCopyWithImpl<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  _$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final ResetPasswordState _self;
  final $Res Function(ResetPasswordState) _then;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? passwordError = freezed,
    Object? passwordConfirmError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResetPasswordStatus,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _self.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
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

/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
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
    TResult Function(_ResetPasswordState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState() when $default != null:
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
    TResult Function(_ResetPasswordState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState():
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
    TResult? Function(_ResetPasswordState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState() when $default != null:
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
            ResetPasswordStatus status,
            String password,
            String passwordConfirm,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState() when $default != null:
        return $default(
            _that.status,
            _that.password,
            _that.passwordConfirm,
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
            ResetPasswordStatus status,
            String password,
            String passwordConfirm,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState():
        return $default(
            _that.status,
            _that.password,
            _that.passwordConfirm,
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
            ResetPasswordStatus status,
            String password,
            String passwordConfirm,
            String? passwordError,
            String? passwordConfirmError,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResetPasswordState() when $default != null:
        return $default(
            _that.status,
            _that.password,
            _that.passwordConfirm,
            _that.passwordError,
            _that.passwordConfirmError,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ResetPasswordState implements ResetPasswordState {
  const _ResetPasswordState(
      {this.status = ResetPasswordStatus.initial,
      this.password = '',
      this.passwordConfirm = '',
      this.passwordError,
      this.passwordConfirmError,
      this.errorMessage});

  @override
  @JsonKey()
  final ResetPasswordStatus status;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String passwordConfirm;
  @override
  final String? passwordError;
  @override
  final String? passwordConfirmError;
  @override
  final String? errorMessage;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResetPasswordStateCopyWith<_ResetPasswordState> get copyWith =>
      __$ResetPasswordStateCopyWithImpl<_ResetPasswordState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResetPasswordState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirm, passwordConfirm) ||
                other.passwordConfirm == passwordConfirm) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.passwordConfirmError, passwordConfirmError) ||
                other.passwordConfirmError == passwordConfirmError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, password,
      passwordConfirm, passwordError, passwordConfirmError, errorMessage);

  @override
  String toString() {
    return 'ResetPasswordState(status: $status, password: $password, passwordConfirm: $passwordConfirm, passwordError: $passwordError, passwordConfirmError: $passwordConfirmError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ResetPasswordStateCopyWith<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  factory _$ResetPasswordStateCopyWith(
          _ResetPasswordState value, $Res Function(_ResetPasswordState) _then) =
      __$ResetPasswordStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ResetPasswordStatus status,
      String password,
      String passwordConfirm,
      String? passwordError,
      String? passwordConfirmError,
      String? errorMessage});
}

/// @nodoc
class __$ResetPasswordStateCopyWithImpl<$Res>
    implements _$ResetPasswordStateCopyWith<$Res> {
  __$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final _ResetPasswordState _self;
  final $Res Function(_ResetPasswordState) _then;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? password = null,
    Object? passwordConfirm = null,
    Object? passwordError = freezed,
    Object? passwordConfirmError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_ResetPasswordState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ResetPasswordStatus,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirm: null == passwordConfirm
          ? _self.passwordConfirm
          : passwordConfirm // ignore: cast_nullable_to_non_nullable
              as String,
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
