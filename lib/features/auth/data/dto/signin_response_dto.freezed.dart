// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInResponseDto {
  String get accessToken;
  String get refreshToken;
  DateTime get accessTokenExpiresIn;
  DateTime get refreshTokenExpiresIn;

  /// Create a copy of SignInResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignInResponseDtoCopyWith<SignInResponseDto> get copyWith =>
      _$SignInResponseDtoCopyWithImpl<SignInResponseDto>(
          this as SignInResponseDto, _$identity);

  /// Serializes this SignInResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInResponseDto &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.accessTokenExpiresIn, accessTokenExpiresIn) ||
                other.accessTokenExpiresIn == accessTokenExpiresIn) &&
            (identical(other.refreshTokenExpiresIn, refreshTokenExpiresIn) ||
                other.refreshTokenExpiresIn == refreshTokenExpiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      accessTokenExpiresIn, refreshTokenExpiresIn);

  @override
  String toString() {
    return 'SignInResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshTokenExpiresIn: $refreshTokenExpiresIn)';
  }
}

/// @nodoc
abstract mixin class $SignInResponseDtoCopyWith<$Res> {
  factory $SignInResponseDtoCopyWith(
          SignInResponseDto value, $Res Function(SignInResponseDto) _then) =
      _$SignInResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      DateTime accessTokenExpiresIn,
      DateTime refreshTokenExpiresIn});
}

/// @nodoc
class _$SignInResponseDtoCopyWithImpl<$Res>
    implements $SignInResponseDtoCopyWith<$Res> {
  _$SignInResponseDtoCopyWithImpl(this._self, this._then);

  final SignInResponseDto _self;
  final $Res Function(SignInResponseDto) _then;

  /// Create a copy of SignInResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshTokenExpiresIn = null,
  }) {
    return _then(_self.copyWith(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresIn: null == accessTokenExpiresIn
          ? _self.accessTokenExpiresIn
          : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refreshTokenExpiresIn: null == refreshTokenExpiresIn
          ? _self.refreshTokenExpiresIn
          : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [SignInResponseDto].
extension SignInResponseDtoPatterns on SignInResponseDto {
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
    TResult Function(_SignInResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto() when $default != null:
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
    TResult Function(_SignInResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto():
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
    TResult? Function(_SignInResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto() when $default != null:
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
    TResult Function(String accessToken, String refreshToken,
            DateTime accessTokenExpiresIn, DateTime refreshTokenExpiresIn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto() when $default != null:
        return $default(_that.accessToken, _that.refreshToken,
            _that.accessTokenExpiresIn, _that.refreshTokenExpiresIn);
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
    TResult Function(String accessToken, String refreshToken,
            DateTime accessTokenExpiresIn, DateTime refreshTokenExpiresIn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto():
        return $default(_that.accessToken, _that.refreshToken,
            _that.accessTokenExpiresIn, _that.refreshTokenExpiresIn);
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
    TResult? Function(String accessToken, String refreshToken,
            DateTime accessTokenExpiresIn, DateTime refreshTokenExpiresIn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SignInResponseDto() when $default != null:
        return $default(_that.accessToken, _that.refreshToken,
            _that.accessTokenExpiresIn, _that.refreshTokenExpiresIn);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SignInResponseDto extends SignInResponseDto {
  const _SignInResponseDto(
      {required this.accessToken,
      required this.refreshToken,
      required this.accessTokenExpiresIn,
      required this.refreshTokenExpiresIn})
      : super._();
  factory _SignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseDtoFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final DateTime accessTokenExpiresIn;
  @override
  final DateTime refreshTokenExpiresIn;

  /// Create a copy of SignInResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SignInResponseDtoCopyWith<_SignInResponseDto> get copyWith =>
      __$SignInResponseDtoCopyWithImpl<_SignInResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SignInResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignInResponseDto &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.accessTokenExpiresIn, accessTokenExpiresIn) ||
                other.accessTokenExpiresIn == accessTokenExpiresIn) &&
            (identical(other.refreshTokenExpiresIn, refreshTokenExpiresIn) ||
                other.refreshTokenExpiresIn == refreshTokenExpiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      accessTokenExpiresIn, refreshTokenExpiresIn);

  @override
  String toString() {
    return 'SignInResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshTokenExpiresIn: $refreshTokenExpiresIn)';
  }
}

/// @nodoc
abstract mixin class _$SignInResponseDtoCopyWith<$Res>
    implements $SignInResponseDtoCopyWith<$Res> {
  factory _$SignInResponseDtoCopyWith(
          _SignInResponseDto value, $Res Function(_SignInResponseDto) _then) =
      __$SignInResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      DateTime accessTokenExpiresIn,
      DateTime refreshTokenExpiresIn});
}

/// @nodoc
class __$SignInResponseDtoCopyWithImpl<$Res>
    implements _$SignInResponseDtoCopyWith<$Res> {
  __$SignInResponseDtoCopyWithImpl(this._self, this._then);

  final _SignInResponseDto _self;
  final $Res Function(_SignInResponseDto) _then;

  /// Create a copy of SignInResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshTokenExpiresIn = null,
  }) {
    return _then(_SignInResponseDto(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresIn: null == accessTokenExpiresIn
          ? _self.accessTokenExpiresIn
          : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      refreshTokenExpiresIn: null == refreshTokenExpiresIn
          ? _self.refreshTokenExpiresIn
          : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
