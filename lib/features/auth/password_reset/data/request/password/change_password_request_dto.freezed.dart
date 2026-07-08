// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangePasswordRequestDto {
  String get email;
  String get verifiedToken;
  String get newPassword;

  /// Create a copy of ChangePasswordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChangePasswordRequestDtoCopyWith<ChangePasswordRequestDto> get copyWith =>
      _$ChangePasswordRequestDtoCopyWithImpl<ChangePasswordRequestDto>(
          this as ChangePasswordRequestDto, _$identity);

  /// Serializes this ChangePasswordRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChangePasswordRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, verifiedToken, newPassword);

  @override
  String toString() {
    return 'ChangePasswordRequestDto(email: $email, verifiedToken: $verifiedToken, newPassword: $newPassword)';
  }
}

/// @nodoc
abstract mixin class $ChangePasswordRequestDtoCopyWith<$Res> {
  factory $ChangePasswordRequestDtoCopyWith(ChangePasswordRequestDto value,
          $Res Function(ChangePasswordRequestDto) _then) =
      _$ChangePasswordRequestDtoCopyWithImpl;
  @useResult
  $Res call({String email, String verifiedToken, String newPassword});
}

/// @nodoc
class _$ChangePasswordRequestDtoCopyWithImpl<$Res>
    implements $ChangePasswordRequestDtoCopyWith<$Res> {
  _$ChangePasswordRequestDtoCopyWithImpl(this._self, this._then);

  final ChangePasswordRequestDto _self;
  final $Res Function(ChangePasswordRequestDto) _then;

  /// Create a copy of ChangePasswordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? verifiedToken = null,
    Object? newPassword = null,
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
      newPassword: null == newPassword
          ? _self.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChangePasswordRequestDto].
extension ChangePasswordRequestDtoPatterns on ChangePasswordRequestDto {
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
    TResult Function(_ChangePasswordRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto() when $default != null:
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
    TResult Function(_ChangePasswordRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto():
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
    TResult? Function(_ChangePasswordRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto() when $default != null:
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
    TResult Function(String email, String verifiedToken, String newPassword)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto() when $default != null:
        return $default(_that.email, _that.verifiedToken, _that.newPassword);
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
    TResult Function(String email, String verifiedToken, String newPassword)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto():
        return $default(_that.email, _that.verifiedToken, _that.newPassword);
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
    TResult? Function(String email, String verifiedToken, String newPassword)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChangePasswordRequestDto() when $default != null:
        return $default(_that.email, _that.verifiedToken, _that.newPassword);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChangePasswordRequestDto implements ChangePasswordRequestDto {
  const _ChangePasswordRequestDto(
      {required this.email,
      required this.verifiedToken,
      required this.newPassword});
  factory _ChangePasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestDtoFromJson(json);

  @override
  final String email;
  @override
  final String verifiedToken;
  @override
  final String newPassword;

  /// Create a copy of ChangePasswordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChangePasswordRequestDtoCopyWith<_ChangePasswordRequestDto> get copyWith =>
      __$ChangePasswordRequestDtoCopyWithImpl<_ChangePasswordRequestDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChangePasswordRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChangePasswordRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.verifiedToken, verifiedToken) ||
                other.verifiedToken == verifiedToken) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, verifiedToken, newPassword);

  @override
  String toString() {
    return 'ChangePasswordRequestDto(email: $email, verifiedToken: $verifiedToken, newPassword: $newPassword)';
  }
}

/// @nodoc
abstract mixin class _$ChangePasswordRequestDtoCopyWith<$Res>
    implements $ChangePasswordRequestDtoCopyWith<$Res> {
  factory _$ChangePasswordRequestDtoCopyWith(_ChangePasswordRequestDto value,
          $Res Function(_ChangePasswordRequestDto) _then) =
      __$ChangePasswordRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String email, String verifiedToken, String newPassword});
}

/// @nodoc
class __$ChangePasswordRequestDtoCopyWithImpl<$Res>
    implements _$ChangePasswordRequestDtoCopyWith<$Res> {
  __$ChangePasswordRequestDtoCopyWithImpl(this._self, this._then);

  final _ChangePasswordRequestDto _self;
  final $Res Function(_ChangePasswordRequestDto) _then;

  /// Create a copy of ChangePasswordRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? verifiedToken = null,
    Object? newPassword = null,
  }) {
    return _then(_ChangePasswordRequestDto(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedToken: null == verifiedToken
          ? _self.verifiedToken
          : verifiedToken // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _self.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
