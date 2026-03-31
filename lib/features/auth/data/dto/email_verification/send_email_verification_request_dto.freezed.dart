// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_email_verification_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendEmailVerificationRequestDto {
  String get email;
  EmailVerificationPurpose get purpose;

  /// Create a copy of SendEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendEmailVerificationRequestDtoCopyWith<SendEmailVerificationRequestDto>
      get copyWith => _$SendEmailVerificationRequestDtoCopyWithImpl<
              SendEmailVerificationRequestDto>(
          this as SendEmailVerificationRequestDto, _$identity);

  /// Serializes this SendEmailVerificationRequestDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendEmailVerificationRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, purpose);

  @override
  String toString() {
    return 'SendEmailVerificationRequestDto(email: $email, purpose: $purpose)';
  }
}

/// @nodoc
abstract mixin class $SendEmailVerificationRequestDtoCopyWith<$Res> {
  factory $SendEmailVerificationRequestDtoCopyWith(
          SendEmailVerificationRequestDto value,
          $Res Function(SendEmailVerificationRequestDto) _then) =
      _$SendEmailVerificationRequestDtoCopyWithImpl;
  @useResult
  $Res call({String email, EmailVerificationPurpose purpose});
}

/// @nodoc
class _$SendEmailVerificationRequestDtoCopyWithImpl<$Res>
    implements $SendEmailVerificationRequestDtoCopyWith<$Res> {
  _$SendEmailVerificationRequestDtoCopyWithImpl(this._self, this._then);

  final SendEmailVerificationRequestDto _self;
  final $Res Function(SendEmailVerificationRequestDto) _then;

  /// Create a copy of SendEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? purpose = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _self.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as EmailVerificationPurpose,
    ));
  }
}

/// Adds pattern-matching-related methods to [SendEmailVerificationRequestDto].
extension SendEmailVerificationRequestDtoPatterns
    on SendEmailVerificationRequestDto {
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
    TResult Function(_SendEmailVerificationRequestDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto() when $default != null:
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
    TResult Function(_SendEmailVerificationRequestDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto():
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
    TResult? Function(_SendEmailVerificationRequestDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto() when $default != null:
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
    TResult Function(String email, EmailVerificationPurpose purpose)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto() when $default != null:
        return $default(_that.email, _that.purpose);
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
    TResult Function(String email, EmailVerificationPurpose purpose) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto():
        return $default(_that.email, _that.purpose);
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
    TResult? Function(String email, EmailVerificationPurpose purpose)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SendEmailVerificationRequestDto() when $default != null:
        return $default(_that.email, _that.purpose);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SendEmailVerificationRequestDto
    implements SendEmailVerificationRequestDto {
  const _SendEmailVerificationRequestDto(
      {required this.email, required this.purpose});
  factory _SendEmailVerificationRequestDto.fromJson(
          Map<String, dynamic> json) =>
      _$SendEmailVerificationRequestDtoFromJson(json);

  @override
  final String email;
  @override
  final EmailVerificationPurpose purpose;

  /// Create a copy of SendEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SendEmailVerificationRequestDtoCopyWith<_SendEmailVerificationRequestDto>
      get copyWith => __$SendEmailVerificationRequestDtoCopyWithImpl<
          _SendEmailVerificationRequestDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SendEmailVerificationRequestDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendEmailVerificationRequestDto &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, purpose);

  @override
  String toString() {
    return 'SendEmailVerificationRequestDto(email: $email, purpose: $purpose)';
  }
}

/// @nodoc
abstract mixin class _$SendEmailVerificationRequestDtoCopyWith<$Res>
    implements $SendEmailVerificationRequestDtoCopyWith<$Res> {
  factory _$SendEmailVerificationRequestDtoCopyWith(
          _SendEmailVerificationRequestDto value,
          $Res Function(_SendEmailVerificationRequestDto) _then) =
      __$SendEmailVerificationRequestDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String email, EmailVerificationPurpose purpose});
}

/// @nodoc
class __$SendEmailVerificationRequestDtoCopyWithImpl<$Res>
    implements _$SendEmailVerificationRequestDtoCopyWith<$Res> {
  __$SendEmailVerificationRequestDtoCopyWithImpl(this._self, this._then);

  final _SendEmailVerificationRequestDto _self;
  final $Res Function(_SendEmailVerificationRequestDto) _then;

  /// Create a copy of SendEmailVerificationRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? purpose = null,
  }) {
    return _then(_SendEmailVerificationRequestDto(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _self.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as EmailVerificationPurpose,
    ));
  }
}

// dart format on
