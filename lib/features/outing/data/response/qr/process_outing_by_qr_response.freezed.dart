// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process_outing_by_qr_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProcessOutingByQrResponse {
  OutingAction get action;
  int get outingId;
  OutingStatusType get status;
  DateTime get outingAt;

  /// Create a copy of ProcessOutingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProcessOutingByQrResponseCopyWith<ProcessOutingByQrResponse> get copyWith =>
      _$ProcessOutingByQrResponseCopyWithImpl<ProcessOutingByQrResponse>(
          this as ProcessOutingByQrResponse, _$identity);

  /// Serializes this ProcessOutingByQrResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProcessOutingByQrResponse &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.outingId, outingId) ||
                other.outingId == outingId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.outingAt, outingAt) ||
                other.outingAt == outingAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, action, outingId, status, outingAt);

  @override
  String toString() {
    return 'ProcessOutingByQrResponse(action: $action, outingId: $outingId, status: $status, outingAt: $outingAt)';
  }
}

/// @nodoc
abstract mixin class $ProcessOutingByQrResponseCopyWith<$Res> {
  factory $ProcessOutingByQrResponseCopyWith(ProcessOutingByQrResponse value,
          $Res Function(ProcessOutingByQrResponse) _then) =
      _$ProcessOutingByQrResponseCopyWithImpl;
  @useResult
  $Res call(
      {OutingAction action,
      int outingId,
      OutingStatusType status,
      DateTime outingAt});
}

/// @nodoc
class _$ProcessOutingByQrResponseCopyWithImpl<$Res>
    implements $ProcessOutingByQrResponseCopyWith<$Res> {
  _$ProcessOutingByQrResponseCopyWithImpl(this._self, this._then);

  final ProcessOutingByQrResponse _self;
  final $Res Function(ProcessOutingByQrResponse) _then;

  /// Create a copy of ProcessOutingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? outingId = null,
    Object? status = null,
    Object? outingAt = null,
  }) {
    return _then(_self.copyWith(
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as OutingAction,
      outingId: null == outingId
          ? _self.outingId
          : outingId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OutingStatusType,
      outingAt: null == outingAt
          ? _self.outingAt
          : outingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProcessOutingByQrResponse].
extension ProcessOutingByQrResponsePatterns on ProcessOutingByQrResponse {
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
    TResult Function(_ProcessOutingByQrResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse() when $default != null:
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
    TResult Function(_ProcessOutingByQrResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse():
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
    TResult? Function(_ProcessOutingByQrResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse() when $default != null:
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
    TResult Function(OutingAction action, int outingId, OutingStatusType status,
            DateTime outingAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse() when $default != null:
        return $default(
            _that.action, _that.outingId, _that.status, _that.outingAt);
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
    TResult Function(OutingAction action, int outingId, OutingStatusType status,
            DateTime outingAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse():
        return $default(
            _that.action, _that.outingId, _that.status, _that.outingAt);
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
    TResult? Function(OutingAction action, int outingId,
            OutingStatusType status, DateTime outingAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessOutingByQrResponse() when $default != null:
        return $default(
            _that.action, _that.outingId, _that.status, _that.outingAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProcessOutingByQrResponse implements ProcessOutingByQrResponse {
  const _ProcessOutingByQrResponse(
      {required this.action,
      required this.outingId,
      required this.status,
      required this.outingAt});
  factory _ProcessOutingByQrResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessOutingByQrResponseFromJson(json);

  @override
  final OutingAction action;
  @override
  final int outingId;
  @override
  final OutingStatusType status;
  @override
  final DateTime outingAt;

  /// Create a copy of ProcessOutingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProcessOutingByQrResponseCopyWith<_ProcessOutingByQrResponse>
      get copyWith =>
          __$ProcessOutingByQrResponseCopyWithImpl<_ProcessOutingByQrResponse>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProcessOutingByQrResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProcessOutingByQrResponse &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.outingId, outingId) ||
                other.outingId == outingId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.outingAt, outingAt) ||
                other.outingAt == outingAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, action, outingId, status, outingAt);

  @override
  String toString() {
    return 'ProcessOutingByQrResponse(action: $action, outingId: $outingId, status: $status, outingAt: $outingAt)';
  }
}

/// @nodoc
abstract mixin class _$ProcessOutingByQrResponseCopyWith<$Res>
    implements $ProcessOutingByQrResponseCopyWith<$Res> {
  factory _$ProcessOutingByQrResponseCopyWith(_ProcessOutingByQrResponse value,
          $Res Function(_ProcessOutingByQrResponse) _then) =
      __$ProcessOutingByQrResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {OutingAction action,
      int outingId,
      OutingStatusType status,
      DateTime outingAt});
}

/// @nodoc
class __$ProcessOutingByQrResponseCopyWithImpl<$Res>
    implements _$ProcessOutingByQrResponseCopyWith<$Res> {
  __$ProcessOutingByQrResponseCopyWithImpl(this._self, this._then);

  final _ProcessOutingByQrResponse _self;
  final $Res Function(_ProcessOutingByQrResponse) _then;

  /// Create a copy of ProcessOutingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? action = null,
    Object? outingId = null,
    Object? status = null,
    Object? outingAt = null,
  }) {
    return _then(_ProcessOutingByQrResponse(
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as OutingAction,
      outingId: null == outingId
          ? _self.outingId
          : outingId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OutingStatusType,
      outingAt: null == outingAt
          ? _self.outingAt
          : outingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
