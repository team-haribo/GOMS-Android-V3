// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'write_review_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WriteReviewState {
  WriteReviewStatus get status;
  String get reviewText;
  String? get errorMessage;

  /// Create a copy of WriteReviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WriteReviewStateCopyWith<WriteReviewState> get copyWith =>
      _$WriteReviewStateCopyWithImpl<WriteReviewState>(
          this as WriteReviewState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WriteReviewState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, reviewText, errorMessage);

  @override
  String toString() {
    return 'WriteReviewState(status: $status, reviewText: $reviewText, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $WriteReviewStateCopyWith<$Res> {
  factory $WriteReviewStateCopyWith(
          WriteReviewState value, $Res Function(WriteReviewState) _then) =
      _$WriteReviewStateCopyWithImpl;
  @useResult
  $Res call(
      {WriteReviewStatus status, String reviewText, String? errorMessage});
}

/// @nodoc
class _$WriteReviewStateCopyWithImpl<$Res>
    implements $WriteReviewStateCopyWith<$Res> {
  _$WriteReviewStateCopyWithImpl(this._self, this._then);

  final WriteReviewState _self;
  final $Res Function(WriteReviewState) _then;

  /// Create a copy of WriteReviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? reviewText = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WriteReviewStatus,
      reviewText: null == reviewText
          ? _self.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WriteReviewState].
extension WriteReviewStatePatterns on WriteReviewState {
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
    TResult Function(_WriteReviewState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState() when $default != null:
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
    TResult Function(_WriteReviewState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState():
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
    TResult? Function(_WriteReviewState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState() when $default != null:
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
            WriteReviewStatus status, String reviewText, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState() when $default != null:
        return $default(_that.status, _that.reviewText, _that.errorMessage);
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
            WriteReviewStatus status, String reviewText, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState():
        return $default(_that.status, _that.reviewText, _that.errorMessage);
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
            WriteReviewStatus status, String reviewText, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WriteReviewState() when $default != null:
        return $default(_that.status, _that.reviewText, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WriteReviewState implements WriteReviewState {
  const _WriteReviewState(
      {this.status = WriteReviewStatus.initial,
      this.reviewText = '',
      this.errorMessage});

  @override
  @JsonKey()
  final WriteReviewStatus status;
  @override
  @JsonKey()
  final String reviewText;
  @override
  final String? errorMessage;

  /// Create a copy of WriteReviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WriteReviewStateCopyWith<_WriteReviewState> get copyWith =>
      __$WriteReviewStateCopyWithImpl<_WriteReviewState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WriteReviewState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, reviewText, errorMessage);

  @override
  String toString() {
    return 'WriteReviewState(status: $status, reviewText: $reviewText, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$WriteReviewStateCopyWith<$Res>
    implements $WriteReviewStateCopyWith<$Res> {
  factory _$WriteReviewStateCopyWith(
          _WriteReviewState value, $Res Function(_WriteReviewState) _then) =
      __$WriteReviewStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {WriteReviewStatus status, String reviewText, String? errorMessage});
}

/// @nodoc
class __$WriteReviewStateCopyWithImpl<$Res>
    implements _$WriteReviewStateCopyWith<$Res> {
  __$WriteReviewStateCopyWithImpl(this._self, this._then);

  final _WriteReviewState _self;
  final $Res Function(_WriteReviewState) _then;

  /// Create a copy of WriteReviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? reviewText = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_WriteReviewState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WriteReviewStatus,
      reviewText: null == reviewText
          ? _self.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
