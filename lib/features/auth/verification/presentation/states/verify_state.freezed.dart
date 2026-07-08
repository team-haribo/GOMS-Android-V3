// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerifyState {
  VerifyStatus get status;
  String get code;
  int get remainingSeconds;
  int get resendCooldownSeconds;
  bool get isExpired;
  String? get codeError;
  String? get errorMessage;

  /// Create a copy of VerifyState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerifyStateCopyWith<VerifyState> get copyWith =>
      _$VerifyStateCopyWithImpl<VerifyState>(this as VerifyState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerifyState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.resendCooldownSeconds, resendCooldownSeconds) ||
                other.resendCooldownSeconds == resendCooldownSeconds) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.codeError, codeError) ||
                other.codeError == codeError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, code, remainingSeconds,
      resendCooldownSeconds, isExpired, codeError, errorMessage);

  @override
  String toString() {
    return 'VerifyState(status: $status, code: $code, remainingSeconds: $remainingSeconds, resendCooldownSeconds: $resendCooldownSeconds, isExpired: $isExpired, codeError: $codeError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $VerifyStateCopyWith<$Res> {
  factory $VerifyStateCopyWith(
          VerifyState value, $Res Function(VerifyState) _then) =
      _$VerifyStateCopyWithImpl;
  @useResult
  $Res call(
      {VerifyStatus status,
      String code,
      int remainingSeconds,
      int resendCooldownSeconds,
      bool isExpired,
      String? codeError,
      String? errorMessage});
}

/// @nodoc
class _$VerifyStateCopyWithImpl<$Res> implements $VerifyStateCopyWith<$Res> {
  _$VerifyStateCopyWithImpl(this._self, this._then);

  final VerifyState _self;
  final $Res Function(VerifyState) _then;

  /// Create a copy of VerifyState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? code = null,
    Object? remainingSeconds = null,
    Object? resendCooldownSeconds = null,
    Object? isExpired = null,
    Object? codeError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VerifyStatus,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      remainingSeconds: null == remainingSeconds
          ? _self.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      resendCooldownSeconds: null == resendCooldownSeconds
          ? _self.resendCooldownSeconds
          : resendCooldownSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isExpired: null == isExpired
          ? _self.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      codeError: freezed == codeError
          ? _self.codeError
          : codeError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VerifyState].
extension VerifyStatePatterns on VerifyState {
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
    TResult Function(_VerifyState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerifyState() when $default != null:
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
    TResult Function(_VerifyState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifyState():
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
    TResult? Function(_VerifyState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifyState() when $default != null:
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
            VerifyStatus status,
            String code,
            int remainingSeconds,
            int resendCooldownSeconds,
            bool isExpired,
            String? codeError,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VerifyState() when $default != null:
        return $default(
            _that.status,
            _that.code,
            _that.remainingSeconds,
            _that.resendCooldownSeconds,
            _that.isExpired,
            _that.codeError,
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
            VerifyStatus status,
            String code,
            int remainingSeconds,
            int resendCooldownSeconds,
            bool isExpired,
            String? codeError,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifyState():
        return $default(
            _that.status,
            _that.code,
            _that.remainingSeconds,
            _that.resendCooldownSeconds,
            _that.isExpired,
            _that.codeError,
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
            VerifyStatus status,
            String code,
            int remainingSeconds,
            int resendCooldownSeconds,
            bool isExpired,
            String? codeError,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VerifyState() when $default != null:
        return $default(
            _that.status,
            _that.code,
            _that.remainingSeconds,
            _that.resendCooldownSeconds,
            _that.isExpired,
            _that.codeError,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VerifyState implements VerifyState {
  const _VerifyState(
      {this.status = VerifyStatus.initial,
      this.code = '',
      this.remainingSeconds = 300,
      this.resendCooldownSeconds = 60,
      this.isExpired = false,
      this.codeError,
      this.errorMessage});

  @override
  @JsonKey()
  final VerifyStatus status;
  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final int remainingSeconds;
  @override
  @JsonKey()
  final int resendCooldownSeconds;
  @override
  @JsonKey()
  final bool isExpired;
  @override
  final String? codeError;
  @override
  final String? errorMessage;

  /// Create a copy of VerifyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerifyStateCopyWith<_VerifyState> get copyWith =>
      __$VerifyStateCopyWithImpl<_VerifyState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerifyState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.resendCooldownSeconds, resendCooldownSeconds) ||
                other.resendCooldownSeconds == resendCooldownSeconds) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.codeError, codeError) ||
                other.codeError == codeError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, code, remainingSeconds,
      resendCooldownSeconds, isExpired, codeError, errorMessage);

  @override
  String toString() {
    return 'VerifyState(status: $status, code: $code, remainingSeconds: $remainingSeconds, resendCooldownSeconds: $resendCooldownSeconds, isExpired: $isExpired, codeError: $codeError, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$VerifyStateCopyWith<$Res>
    implements $VerifyStateCopyWith<$Res> {
  factory _$VerifyStateCopyWith(
          _VerifyState value, $Res Function(_VerifyState) _then) =
      __$VerifyStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {VerifyStatus status,
      String code,
      int remainingSeconds,
      int resendCooldownSeconds,
      bool isExpired,
      String? codeError,
      String? errorMessage});
}

/// @nodoc
class __$VerifyStateCopyWithImpl<$Res> implements _$VerifyStateCopyWith<$Res> {
  __$VerifyStateCopyWithImpl(this._self, this._then);

  final _VerifyState _self;
  final $Res Function(_VerifyState) _then;

  /// Create a copy of VerifyState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? code = null,
    Object? remainingSeconds = null,
    Object? resendCooldownSeconds = null,
    Object? isExpired = null,
    Object? codeError = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_VerifyState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as VerifyStatus,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      remainingSeconds: null == remainingSeconds
          ? _self.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      resendCooldownSeconds: null == resendCooldownSeconds
          ? _self.resendCooldownSeconds
          : resendCooldownSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isExpired: null == isExpired
          ? _self.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      codeError: freezed == codeError
          ? _self.codeError
          : codeError // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
