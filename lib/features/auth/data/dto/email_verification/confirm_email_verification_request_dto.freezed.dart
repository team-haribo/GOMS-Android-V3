// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirm_email_verification_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfirmEmailVerificationRequestDto {
  String get email;
  String get code;
  EmailVerificationPurpose get purpose;

  /// Create a copy of ConfirmEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfirmEmailVerificationRequestDtoCopyWith<
          ConfirmEmailVerificationRequestDto>
      get copyWith => _$ConfirmEmailVerificationRequestDtoCopyWithImpl<
              ConfirmEmailVerificationRequestDto>(
          this as ConfirmEmailVerificationRequestDto, _$identity);

  /// Serializes this ConfirmEmailVerificationRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfirmEmailVerificationRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, code, purpose);

  @override
  String toString() {
    return 'ConfirmEmailVerificationRequestDto(email: $email, code: $code, purpose: $purpose)';
  }
}

/// @nodoc
abstract mixin class $ConfirmEmailVerificationRequestDtoCopyWith<$Res> {
  factory $ConfirmEmailVerificationRequestDtoCopyWith(
          ConfirmEmailVerificationRequestDto value,
          $Res Function(ConfirmEmailVerificationRequestDto) _then) =
      _$ConfirmEmailVerificationRequestDtoCopyWithImpl;
  @useResult
  $Res call({String email, String code, EmailVerificationPurpose purpose});
}

/// @nodoc
class _$ConfirmEmailVerificationRequestDtoCopyWithImpl<$Res>
    implements $ConfirmEmailVerificationRequestDtoCopyWith<$Res> {
  _$ConfirmEmailVerificationRequestDtoCopyWithImpl(this._self, this._then);

  final ConfirmEmailVerificationRequestDto _self;
  final $Res Function(ConfirmEmailVerificationRequestDto) _then;

  /// Create a copy of ConfirmEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? purpose = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _self.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as EmailVerificationPurpose,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfirmEmailVerificationRequestDto].
extension ConfirmEmailVerificationRequestDtoPatterns
    on ConfirmEmailVerificationRequestDto {
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
    TResult Function(_ConfirmEmailVerificationRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto() when $default != null:
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
    TResult Function(_ConfirmEmailVerificationRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto():
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
    TResult? Function(_ConfirmEmailVerificationRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto() when $default != null:
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
            String email, String code, EmailVerificationPurpose purpose)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto() when $default != null:
        return $default(_that.email, _that.code, _that.purpose);
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
            String email, String code, EmailVerificationPurpose purpose)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto():
        return $default(_that.email, _that.code, _that.purpose);
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
            String email, String code, EmailVerificationPurpose purpose)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfirmEmailVerificationRequestDto() when $default != null:
        return $default(_that.email, _that.code, _that.purpose);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConfirmEmailVerificationRequestDto
    implements ConfirmEmailVerificationRequestDto {
  const _ConfirmEmailVerificationRequestDto(
      {required this.email, required this.code, required this.purpose});
  factory _ConfirmEmailVerificationRequestDto.fromJson(
          Map<String, dynamic> json) =>
      _$ConfirmEmailVerificationRequestDtoFromJson(json);

  @override
  final String email;
  @override
  final String code;
  @override
  final EmailVerificationPurpose purpose;

  /// Create a copy of ConfirmEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfirmEmailVerificationRequestDtoCopyWith<
          _ConfirmEmailVerificationRequestDto>
      get copyWith => __$ConfirmEmailVerificationRequestDtoCopyWithImpl<
          _ConfirmEmailVerificationRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConfirmEmailVerificationRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfirmEmailVerificationRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, code, purpose);

  @override
  String toString() {
    return 'ConfirmEmailVerificationRequestDto(email: $email, code: $code, purpose: $purpose)';
  }
}

/// @nodoc
abstract mixin class _$ConfirmEmailVerificationRequestDtoCopyWith<$Res>
    implements $ConfirmEmailVerificationRequestDtoCopyWith<$Res> {
  factory _$ConfirmEmailVerificationRequestDtoCopyWith(
          _ConfirmEmailVerificationRequestDto value,
          $Res Function(_ConfirmEmailVerificationRequestDto) _then) =
      __$ConfirmEmailVerificationRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String email, String code, EmailVerificationPurpose purpose});
}

/// @nodoc
class __$ConfirmEmailVerificationRequestDtoCopyWithImpl<$Res>
    implements _$ConfirmEmailVerificationRequestDtoCopyWith<$Res> {
  __$ConfirmEmailVerificationRequestDtoCopyWithImpl(this._self, this._then);

  final _ConfirmEmailVerificationRequestDto _self;
  final $Res Function(_ConfirmEmailVerificationRequestDto) _then;

  /// Create a copy of ConfirmEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? purpose = null,
  }) {
    return _then(_ConfirmEmailVerificationRequestDto(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _self.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as EmailVerificationPurpose,
    ));
  }
}

// dart format on
