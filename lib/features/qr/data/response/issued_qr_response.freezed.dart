// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issued_qr_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IssuedQrResponse {
  String get uuid;
  int get exp;

  /// Create a copy of IssuedQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IssuedQrResponseCopyWith<IssuedQrResponse> get copyWith =>
      _$IssuedQrResponseCopyWithImpl<IssuedQrResponse>(
          this as IssuedQrResponse, _$identity);

  /// Serializes this IssuedQrResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IssuedQrResponse &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.exp, exp) || other.exp == exp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, exp);

  @override
  String toString() {
    return 'IssuedQrResponse(uuid: $uuid, exp: $exp)';
  }
}

/// @nodoc
abstract mixin class $IssuedQrResponseCopyWith<$Res> {
  factory $IssuedQrResponseCopyWith(
          IssuedQrResponse value, $Res Function(IssuedQrResponse) _then) =
      _$IssuedQrResponseCopyWithImpl;
  @useResult
  $Res call({String uuid, int exp});
}

/// @nodoc
class _$IssuedQrResponseCopyWithImpl<$Res>
    implements $IssuedQrResponseCopyWith<$Res> {
  _$IssuedQrResponseCopyWithImpl(this._self, this._then);

  final IssuedQrResponse _self;
  final $Res Function(IssuedQrResponse) _then;

  /// Create a copy of IssuedQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? exp = null,
  }) {
    return _then(_self.copyWith(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      exp: null == exp
          ? _self.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [IssuedQrResponse].
extension IssuedQrResponsePatterns on IssuedQrResponse {
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
    TResult Function(_IssuedQrResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse() when $default != null:
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
    TResult Function(_IssuedQrResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse():
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
    TResult? Function(_IssuedQrResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse() when $default != null:
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
    TResult Function(String uuid, int exp)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse() when $default != null:
        return $default(_that.uuid, _that.exp);
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
    TResult Function(String uuid, int exp) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse():
        return $default(_that.uuid, _that.exp);
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
    TResult? Function(String uuid, int exp)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IssuedQrResponse() when $default != null:
        return $default(_that.uuid, _that.exp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _IssuedQrResponse implements IssuedQrResponse {
  const _IssuedQrResponse({required this.uuid, required this.exp});
  factory _IssuedQrResponse.fromJson(Map<String, dynamic> json) =>
      _$IssuedQrResponseFromJson(json);

  @override
  final String uuid;
  @override
  final int exp;

  /// Create a copy of IssuedQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IssuedQrResponseCopyWith<_IssuedQrResponse> get copyWith =>
      __$IssuedQrResponseCopyWithImpl<_IssuedQrResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IssuedQrResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IssuedQrResponse &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.exp, exp) || other.exp == exp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, exp);

  @override
  String toString() {
    return 'IssuedQrResponse(uuid: $uuid, exp: $exp)';
  }
}

/// @nodoc
abstract mixin class _$IssuedQrResponseCopyWith<$Res>
    implements $IssuedQrResponseCopyWith<$Res> {
  factory _$IssuedQrResponseCopyWith(
          _IssuedQrResponse value, $Res Function(_IssuedQrResponse) _then) =
      __$IssuedQrResponseCopyWithImpl;
  @override
  @useResult
  $Res call({String uuid, int exp});
}

/// @nodoc
class __$IssuedQrResponseCopyWithImpl<$Res>
    implements _$IssuedQrResponseCopyWith<$Res> {
  __$IssuedQrResponseCopyWithImpl(this._self, this._then);

  final _IssuedQrResponse _self;
  final $Res Function(_IssuedQrResponse) _then;

  /// Create a copy of IssuedQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uuid = null,
    Object? exp = null,
  }) {
    return _then(_IssuedQrResponse(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      exp: null == exp
          ? _self.exp
          : exp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
