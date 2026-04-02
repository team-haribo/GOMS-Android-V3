// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirm_email_verification_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfirmEmailVerificationResponseDto {
  String get verifiedToken;

  /// Create a copy of ConfirmEmailVerificationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfirmEmailVerificationResponseDtoCopyWith<
          ConfirmEmailVerificationResponseDto>
      get copyWith => _$ConfirmEmailVerificationResponseDtoCopyWithImpl<
              ConfirmEmailVerificationResponseDto>(
          this as ConfirmEmailVerificationResponseDto, _$identity);

  /// Serializes this ConfirmEmailVerificationResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfirmEmailVerificationResponseDto &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, verifiedToken);

  @override
  String toString() {
    return 'ConfirmEmailVerificationResponseDto(verifiedToken: $verifiedToken)';
  }
}

/// @nodoc
abstract mixin class $ConfirmEmailVerificationResponseDtoCopyWith<$Res> {
  factory $ConfirmEmailVerificationResponseDtoCopyWith(
          ConfirmEmailVerificationResponseDto value,
          $Res Function(ConfirmEmailVerificationResponseDto) _then) =
      _$ConfirmEmailVerificationResponseDtoCopyWithImpl;
  @useResult
  $Res call({String verifiedToken});
}

/// @nodoc
class _$ConfirmEmailVerificationResponseDtoCopyWithImpl<$Res>
    implements $ConfirmEmailVerificationResponseDtoCopyWith<$Res> {
  _$ConfirmEmailVerificationResponseDtoCopyWithImpl(this._self, this._then);

  final ConfirmEmailVerificationResponseDto _self;
  final $Res Function(ConfirmEmailVerificationResponseDto) _then;

  /// Create a copy of ConfirmEmailVerificationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verifiedToken = null,
  }) {
    return _then(_self.copyWith(
      verifiedToken: null == verifiedToken
          ? _self.verifiedToken
          : verifiedToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfirmEmailVerificationResponseDto].
extension ConfirmEmailVerificationResponseDtoPatterns
    on ConfirmEmailVerificationResponseDto {
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
    TResult Function(_ConfirmEmailVerificationResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto() when $default != null:
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
    TResult Function(_ConfirmEmailVerificationResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto():
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
    TResult? Function(_ConfirmEmailVerificationResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto() when $default != null:
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
    TResult Function(String verifiedToken)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto() when $default != null:
        return $default(_that.verifiedToken);
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
    TResult Function(String verifiedToken) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto():
        return $default(_that.verifiedToken);
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
    TResult? Function(String verifiedToken)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationResponseDto() when $default != null:
        return $default(_that.verifiedToken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConfirmEmailVerificationResponseDto
    implements ConfirmEmailVerificationResponseDto {
  const _ConfirmEmailVerificationResponseDto({required this.verifiedToken});
  factory _ConfirmEmailVerificationResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$ConfirmEmailVerificationResponseDtoFromJson(json);

  @override
  final String verifiedToken;

  /// Create a copy of ConfirmEmailVerificationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfirmEmailVerificationResponseDtoCopyWith<
          _ConfirmEmailVerificationResponseDto>
      get copyWith => __$ConfirmEmailVerificationResponseDtoCopyWithImpl<
          _ConfirmEmailVerificationResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfirmEmailVerificationResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfirmEmailVerificationResponseDto &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, verifiedToken);

  @override
  String toString() {
    return 'ConfirmEmailVerificationResponseDto(verifiedToken: $verifiedToken)';
  }
}

/// @nodoc
abstract mixin class _$ConfirmEmailVerificationResponseDtoCopyWith<$Res>
    implements $ConfirmEmailVerificationResponseDtoCopyWith<$Res> {
  factory _$ConfirmEmailVerificationResponseDtoCopyWith(
          _ConfirmEmailVerificationResponseDto value,
          $Res Function(_ConfirmEmailVerificationResponseDto) _then) =
      __$ConfirmEmailVerificationResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String verifiedToken});
}

/// @nodoc
class __$ConfirmEmailVerificationResponseDtoCopyWithImpl<$Res>
    implements _$ConfirmEmailVerificationResponseDtoCopyWith<$Res> {
  __$ConfirmEmailVerificationResponseDtoCopyWithImpl(this._self, this._then);

  final _ConfirmEmailVerificationResponseDto _self;
  final $Res Function(_ConfirmEmailVerificationResponseDto) _then;

  /// Create a copy of ConfirmEmailVerificationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? verifiedToken = null,
  }) {
    return _then(_ConfirmEmailVerificationResponseDto(
      verifiedToken: null == verifiedToken
          ? _self.verifiedToken
          : verifiedToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
