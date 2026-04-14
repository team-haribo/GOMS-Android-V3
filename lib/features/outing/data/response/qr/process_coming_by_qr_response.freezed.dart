// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'process_coming_by_qr_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProcessComingByQrResponse {
  OutingAction get action;
  int get outingId;
  OutingStatusType get status;
  DateTime get comingAt;
  bool get lateCreated;
  int? get lateId;

  /// Create a copy of ProcessComingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProcessComingByQrResponseCopyWith<ProcessComingByQrResponse> get copyWith =>
      _$ProcessComingByQrResponseCopyWithImpl<ProcessComingByQrResponse>(
          this as ProcessComingByQrResponse, _$identity);

  /// Serializes this ProcessComingByQrResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProcessComingByQrResponse &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.outingId, outingId) ||
                other.outingId == outingId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comingAt, comingAt) ||
                other.comingAt == comingAt) &&
            (identical(other.lateCreated, lateCreated) ||
                other.lateCreated == lateCreated) &&
            (identical(other.lateId, lateId) || other.lateId == lateId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, action, outingId, status, comingAt, lateCreated, lateId);

  @override
  String toString() {
    return 'ProcessComingByQrResponse(action: $action, outingId: $outingId, status: $status, comingAt: $comingAt, lateCreated: $lateCreated, lateId: $lateId)';
  }
}

/// @nodoc
abstract mixin class $ProcessComingByQrResponseCopyWith<$Res> {
  factory $ProcessComingByQrResponseCopyWith(ProcessComingByQrResponse value,
          $Res Function(ProcessComingByQrResponse) _then) =
      _$ProcessComingByQrResponseCopyWithImpl;
  @useResult
  $Res call(
      {OutingAction action,
      int outingId,
      OutingStatusType status,
      DateTime comingAt,
      bool lateCreated,
      int? lateId});
}

/// @nodoc
class _$ProcessComingByQrResponseCopyWithImpl<$Res>
    implements $ProcessComingByQrResponseCopyWith<$Res> {
  _$ProcessComingByQrResponseCopyWithImpl(this._self, this._then);

  final ProcessComingByQrResponse _self;
  final $Res Function(ProcessComingByQrResponse) _then;

  /// Create a copy of ProcessComingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? outingId = null,
    Object? status = null,
    Object? comingAt = null,
    Object? lateCreated = null,
    Object? lateId = freezed,
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
      comingAt: null == comingAt
          ? _self.comingAt
          : comingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lateCreated: null == lateCreated
          ? _self.lateCreated
          : lateCreated // ignore: cast_nullable_to_non_nullable
              as bool,
      lateId: freezed == lateId
          ? _self.lateId
          : lateId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProcessComingByQrResponse].
extension ProcessComingByQrResponsePatterns on ProcessComingByQrResponse {
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
    TResult Function(_ProcessComingByQrResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse() when $default != null:
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
    TResult Function(_ProcessComingByQrResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse():
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
    TResult? Function(_ProcessComingByQrResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse() when $default != null:
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
            DateTime comingAt, bool lateCreated, int? lateId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse() when $default != null:
        return $default(_that.action, _that.outingId, _that.status,
            _that.comingAt, _that.lateCreated, _that.lateId);
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
            DateTime comingAt, bool lateCreated, int? lateId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse():
        return $default(_that.action, _that.outingId, _that.status,
            _that.comingAt, _that.lateCreated, _that.lateId);
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
            OutingAction action,
            int outingId,
            OutingStatusType status,
            DateTime comingAt,
            bool lateCreated,
            int? lateId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProcessComingByQrResponse() when $default != null:
        return $default(_that.action, _that.outingId, _that.status,
            _that.comingAt, _that.lateCreated, _that.lateId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProcessComingByQrResponse implements ProcessComingByQrResponse {
  const _ProcessComingByQrResponse(
      {required this.action,
      required this.outingId,
      required this.status,
      required this.comingAt,
      required this.lateCreated,
      required this.lateId});
  factory _ProcessComingByQrResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessComingByQrResponseFromJson(json);

  @override
  final OutingAction action;
  @override
  final int outingId;
  @override
  final OutingStatusType status;
  @override
  final DateTime comingAt;
  @override
  final bool lateCreated;
  @override
  final int? lateId;

  /// Create a copy of ProcessComingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProcessComingByQrResponseCopyWith<_ProcessComingByQrResponse>
      get copyWith =>
          __$ProcessComingByQrResponseCopyWithImpl<_ProcessComingByQrResponse>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProcessComingByQrResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProcessComingByQrResponse &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.outingId, outingId) ||
                other.outingId == outingId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comingAt, comingAt) ||
                other.comingAt == comingAt) &&
            (identical(other.lateCreated, lateCreated) ||
                other.lateCreated == lateCreated) &&
            (identical(other.lateId, lateId) || other.lateId == lateId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, action, outingId, status, comingAt, lateCreated, lateId);

  @override
  String toString() {
    return 'ProcessComingByQrResponse(action: $action, outingId: $outingId, status: $status, comingAt: $comingAt, lateCreated: $lateCreated, lateId: $lateId)';
  }
}

/// @nodoc
abstract mixin class _$ProcessComingByQrResponseCopyWith<$Res>
    implements $ProcessComingByQrResponseCopyWith<$Res> {
  factory _$ProcessComingByQrResponseCopyWith(_ProcessComingByQrResponse value,
          $Res Function(_ProcessComingByQrResponse) _then) =
      __$ProcessComingByQrResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {OutingAction action,
      int outingId,
      OutingStatusType status,
      DateTime comingAt,
      bool lateCreated,
      int? lateId});
}

/// @nodoc
class __$ProcessComingByQrResponseCopyWithImpl<$Res>
    implements _$ProcessComingByQrResponseCopyWith<$Res> {
  __$ProcessComingByQrResponseCopyWithImpl(this._self, this._then);

  final _ProcessComingByQrResponse _self;
  final $Res Function(_ProcessComingByQrResponse) _then;

  /// Create a copy of ProcessComingByQrResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? action = null,
    Object? outingId = null,
    Object? status = null,
    Object? comingAt = null,
    Object? lateCreated = null,
    Object? lateId = freezed,
  }) {
    return _then(_ProcessComingByQrResponse(
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
      comingAt: null == comingAt
          ? _self.comingAt
          : comingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lateCreated: null == lateCreated
          ? _self.lateCreated
          : lateCreated // ignore: cast_nullable_to_non_nullable
              as bool,
      lateId: freezed == lateId
          ? _self.lateId
          : lateId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
