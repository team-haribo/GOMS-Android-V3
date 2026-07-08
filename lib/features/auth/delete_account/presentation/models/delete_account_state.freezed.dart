// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteAccountState {
  DeleteAccountStatus get status;
  String get password;
  String? get passwordError;
  String? get errorMessage;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteAccountStateCopyWith<DeleteAccountState> get copyWith =>
      _$DeleteAccountStateCopyWithImpl<DeleteAccountState>(
          this as DeleteAccountState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteAccountState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, password, passwordError, errorMessage);

  @override
  String toString() {
    return 'DeleteAccountState(status: $status, password: $password, passwordError: $passwordError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $DeleteAccountStateCopyWith<$Res> {
  factory $DeleteAccountStateCopyWith(
          DeleteAccountState value, $Res Function(DeleteAccountState) _then) =
      _$DeleteAccountStateCopyWithImpl;
  @useResult
  $Res call(
      {DeleteAccountStatus status,
      String password,
      String? passwordError,
      String? errorMessage});
}

/// @nodoc
class _$DeleteAccountStateCopyWithImpl<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  _$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final DeleteAccountState _self;
  final $Res Function(DeleteAccountState) _then;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? password = null,
    Object? passwordError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeleteAccountStatus,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DeleteAccountState].
extension DeleteAccountStatePatterns on DeleteAccountState {
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
    TResult Function(_DeleteAccountState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState() when $default != null:
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
    TResult Function(_DeleteAccountState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState():
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
    TResult? Function(_DeleteAccountState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState() when $default != null:
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
    TResult Function(DeleteAccountStatus status, String password,
            String? passwordError, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState() when $default != null:
        return $default(_that.status, _that.password, _that.passwordError,
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
    TResult Function(DeleteAccountStatus status, String password,
            String? passwordError, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState():
        return $default(_that.status, _that.password, _that.passwordError,
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
    TResult? Function(DeleteAccountStatus status, String password,
            String? passwordError, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountState() when $default != null:
        return $default(_that.status, _that.password, _that.passwordError,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DeleteAccountState implements DeleteAccountState {
  const _DeleteAccountState(
      {this.status = DeleteAccountStatus.initial,
      this.password = '',
      this.passwordError,
      this.errorMessage});

  @override
  @JsonKey()
  final DeleteAccountStatus status;
  @override
  @JsonKey()
  final String password;
  @override
  final String? passwordError;
  @override
  final String? errorMessage;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteAccountStateCopyWith<_DeleteAccountState> get copyWith =>
      __$DeleteAccountStateCopyWithImpl<_DeleteAccountState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteAccountState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, password, passwordError, errorMessage);

  @override
  String toString() {
    return 'DeleteAccountState(status: $status, password: $password, passwordError: $passwordError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$DeleteAccountStateCopyWith<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  factory _$DeleteAccountStateCopyWith(
          _DeleteAccountState value, $Res Function(_DeleteAccountState) _then) =
      __$DeleteAccountStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DeleteAccountStatus status,
      String password,
      String? passwordError,
      String? errorMessage});
}

/// @nodoc
class __$DeleteAccountStateCopyWithImpl<$Res>
    implements _$DeleteAccountStateCopyWith<$Res> {
  __$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final _DeleteAccountState _self;
  final $Res Function(_DeleteAccountState) _then;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? password = null,
    Object? passwordError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_DeleteAccountState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DeleteAccountStatus,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordError: freezed == passwordError
          ? _self.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
