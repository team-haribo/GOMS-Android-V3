// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_review_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyReviewResponse {
  int get reviewId;
  int get placeId;
  String get placeName;
  String get categoryName;
  String get address;
  String get content;
  DateTime? get reviewedAt;

  /// Create a copy of MyReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyReviewResponseCopyWith<MyReviewResponse> get copyWith =>
      _$MyReviewResponseCopyWithImpl<MyReviewResponse>(
          this as MyReviewResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyReviewResponse &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reviewId, placeId, placeName,
      categoryName, address, content, reviewedAt);

  @override
  String toString() {
    return 'MyReviewResponse(reviewId: $reviewId, placeId: $placeId, placeName: $placeName, categoryName: $categoryName, address: $address, content: $content, reviewedAt: $reviewedAt)';
  }
}

/// @nodoc
abstract mixin class $MyReviewResponseCopyWith<$Res> {
  factory $MyReviewResponseCopyWith(
          MyReviewResponse value, $Res Function(MyReviewResponse) _then) =
      _$MyReviewResponseCopyWithImpl;
  @useResult
  $Res call(
      {int reviewId,
      int placeId,
      String placeName,
      String categoryName,
      String address,
      String content,
      DateTime? reviewedAt});
}

/// @nodoc
class _$MyReviewResponseCopyWithImpl<$Res>
    implements $MyReviewResponseCopyWith<$Res> {
  _$MyReviewResponseCopyWithImpl(this._self, this._then);

  final MyReviewResponse _self;
  final $Res Function(MyReviewResponse) _then;

  /// Create a copy of MyReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewId = null,
    Object? placeId = null,
    Object? placeName = null,
    Object? categoryName = null,
    Object? address = null,
    Object? content = null,
    Object? reviewedAt = freezed,
  }) {
    return _then(_self.copyWith(
      reviewId: null == reviewId
          ? _self.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int,
      placeId: null == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int,
      placeName: null == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedAt: freezed == reviewedAt
          ? _self.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MyReviewResponse].
extension MyReviewResponsePatterns on MyReviewResponse {
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
    TResult Function(_MyReviewResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse() when $default != null:
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
    TResult Function(_MyReviewResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse():
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
    TResult? Function(_MyReviewResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse() when $default != null:
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
            int reviewId,
            int placeId,
            String placeName,
            String categoryName,
            String address,
            String content,
            DateTime? reviewedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse() when $default != null:
        return $default(_that.reviewId, _that.placeId, _that.placeName,
            _that.categoryName, _that.address, _that.content, _that.reviewedAt);
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
            int reviewId,
            int placeId,
            String placeName,
            String categoryName,
            String address,
            String content,
            DateTime? reviewedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse():
        return $default(_that.reviewId, _that.placeId, _that.placeName,
            _that.categoryName, _that.address, _that.content, _that.reviewedAt);
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
            int reviewId,
            int placeId,
            String placeName,
            String categoryName,
            String address,
            String content,
            DateTime? reviewedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyReviewResponse() when $default != null:
        return $default(_that.reviewId, _that.placeId, _that.placeName,
            _that.categoryName, _that.address, _that.content, _that.reviewedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _MyReviewResponse extends MyReviewResponse {
  const _MyReviewResponse(
      {required this.reviewId,
      required this.placeId,
      required this.placeName,
      required this.categoryName,
      required this.address,
      required this.content,
      required this.reviewedAt})
      : super._();
  factory _MyReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$MyReviewResponseFromJson(json);

  @override
  final int reviewId;
  @override
  final int placeId;
  @override
  final String placeName;
  @override
  final String categoryName;
  @override
  final String address;
  @override
  final String content;
  @override
  final DateTime? reviewedAt;

  /// Create a copy of MyReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyReviewResponseCopyWith<_MyReviewResponse> get copyWith =>
      __$MyReviewResponseCopyWithImpl<_MyReviewResponse>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyReviewResponse &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reviewId, placeId, placeName,
      categoryName, address, content, reviewedAt);

  @override
  String toString() {
    return 'MyReviewResponse(reviewId: $reviewId, placeId: $placeId, placeName: $placeName, categoryName: $categoryName, address: $address, content: $content, reviewedAt: $reviewedAt)';
  }
}

/// @nodoc
abstract mixin class _$MyReviewResponseCopyWith<$Res>
    implements $MyReviewResponseCopyWith<$Res> {
  factory _$MyReviewResponseCopyWith(
          _MyReviewResponse value, $Res Function(_MyReviewResponse) _then) =
      __$MyReviewResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int reviewId,
      int placeId,
      String placeName,
      String categoryName,
      String address,
      String content,
      DateTime? reviewedAt});
}

/// @nodoc
class __$MyReviewResponseCopyWithImpl<$Res>
    implements _$MyReviewResponseCopyWith<$Res> {
  __$MyReviewResponseCopyWithImpl(this._self, this._then);

  final _MyReviewResponse _self;
  final $Res Function(_MyReviewResponse) _then;

  /// Create a copy of MyReviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reviewId = null,
    Object? placeId = null,
    Object? placeName = null,
    Object? categoryName = null,
    Object? address = null,
    Object? content = null,
    Object? reviewedAt = freezed,
  }) {
    return _then(_MyReviewResponse(
      reviewId: null == reviewId
          ? _self.reviewId
          : reviewId // ignore: cast_nullable_to_non_nullable
              as int,
      placeId: null == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int,
      placeName: null == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedAt: freezed == reviewedAt
          ? _self.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
