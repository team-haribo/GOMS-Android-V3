// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FindPasswordState {
  FindPasswordStatus get status;
  String get email;
  String? get emailError;
  String? get errorMessage;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FindPasswordStateCopyWith<FindPasswordState> get copyWith =>
      _$FindPasswordStateCopyWithImpl<FindPasswordState>(
          this as FindPasswordState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FindPasswordState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, email, emailError, errorMessage);

  @override
  String toString() {
    return 'FindPasswordState(status: $status, email: $email, emailError: $emailError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $FindPasswordStateCopyWith<$Res> {
  factory $FindPasswordStateCopyWith(
          FindPasswordState value, $Res Function(FindPasswordState) _then) =
      _$FindPasswordStateCopyWithImpl;
  @useResult
  $Res call(
      {FindPasswordStatus status,
      String email,
      String? emailError,
      String? errorMessage});
}

/// @nodoc
class _$FindPasswordStateCopyWithImpl<$Res>
    implements $FindPasswordStateCopyWith<$Res> {
  _$FindPasswordStateCopyWithImpl(this._self, this._then);

  final FindPasswordState _self;
  final $Res Function(FindPasswordState) _then;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? email = null,
    Object? emailError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as FindPasswordStatus,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FindPasswordState].
extension FindPasswordStatePatterns on FindPasswordState {
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
    TResult Function(_FindPasswordState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState() when $default != null:
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
    TResult Function(_FindPasswordState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState():
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
    TResult? Function(_FindPasswordState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState() when $default != null:
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
    TResult Function(FindPasswordStatus status, String email,
            String? emailError, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState() when $default != null:
        return $default(
            _that.status, _that.email, _that.emailError, _that.errorMessage);
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
    TResult Function(FindPasswordStatus status, String email,
            String? emailError, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState():
        return $default(
            _that.status, _that.email, _that.emailError, _that.errorMessage);
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
    TResult? Function(FindPasswordStatus status, String email,
            String? emailError, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FindPasswordState() when $default != null:
        return $default(
            _that.status, _that.email, _that.emailError, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FindPasswordState implements FindPasswordState {
  const _FindPasswordState(
      {this.status = FindPasswordStatus.initial,
      this.email = '',
      this.emailError,
      this.errorMessage});

  @override
  @JsonKey()
  final FindPasswordStatus status;
  @override
  @JsonKey()
  final String email;
  @override
  final String? emailError;
  @override
  final String? errorMessage;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FindPasswordStateCopyWith<_FindPasswordState> get copyWith =>
      __$FindPasswordStateCopyWithImpl<_FindPasswordState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FindPasswordState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, email, emailError, errorMessage);

  @override
  String toString() {
    return 'FindPasswordState(status: $status, email: $email, emailError: $emailError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$FindPasswordStateCopyWith<$Res>
    implements $FindPasswordStateCopyWith<$Res> {
  factory _$FindPasswordStateCopyWith(
          _FindPasswordState value, $Res Function(_FindPasswordState) _then) =
      __$FindPasswordStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {FindPasswordStatus status,
      String email,
      String? emailError,
      String? errorMessage});
}

/// @nodoc
class __$FindPasswordStateCopyWithImpl<$Res>
    implements _$FindPasswordStateCopyWith<$Res> {
  __$FindPasswordStateCopyWithImpl(this._self, this._then);

  final _FindPasswordState _self;
  final $Res Function(_FindPasswordState) _then;

  /// Create a copy of FindPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? email = null,
    Object? emailError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_FindPasswordState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as FindPasswordStatus,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailError: freezed == emailError
          ? _self.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
