// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapPageState {
  MapPageStatus get status;
  List<PopularPlace> get popularPlaces;
  List<MapPageReviewModel> get reviewModels;
  int get recommendedCount;
  int get reviewCount;
  String? get errorMessage;

  /// Create a copy of MapPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapPageStateCopyWith<MapPageState> get copyWith =>
      _$MapPageStateCopyWithImpl<MapPageState>(
          this as MapPageState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapPageState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.popularPlaces, popularPlaces) &&
            const DeepCollectionEquality()
                .equals(other.reviewModels, reviewModels) &&
            (identical(other.recommendedCount, recommendedCount) ||
                other.recommendedCount == recommendedCount) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(popularPlaces),
      const DeepCollectionEquality().hash(reviewModels),
      recommendedCount,
      reviewCount,
      errorMessage);

  @override
  String toString() {
    return 'MapPageState(status: $status, popularPlaces: $popularPlaces, reviewModels: $reviewModels, recommendedCount: $recommendedCount, reviewCount: $reviewCount, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $MapPageStateCopyWith<$Res> {
  factory $MapPageStateCopyWith(
          MapPageState value, $Res Function(MapPageState) _then) =
      _$MapPageStateCopyWithImpl;
  @useResult
  $Res call(
      {MapPageStatus status,
      List<PopularPlace> popularPlaces,
      List<MapPageReviewModel> reviewModels,
      int recommendedCount,
      int reviewCount,
      String? errorMessage});
}

/// @nodoc
class _$MapPageStateCopyWithImpl<$Res> implements $MapPageStateCopyWith<$Res> {
  _$MapPageStateCopyWithImpl(this._self, this._then);

  final MapPageState _self;
  final $Res Function(MapPageState) _then;

  /// Create a copy of MapPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? popularPlaces = null,
    Object? reviewModels = null,
    Object? recommendedCount = null,
    Object? reviewCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MapPageStatus,
      popularPlaces: null == popularPlaces
          ? _self.popularPlaces
          : popularPlaces // ignore: cast_nullable_to_non_nullable
              as List<PopularPlace>,
      reviewModels: null == reviewModels
          ? _self.reviewModels
          : reviewModels // ignore: cast_nullable_to_non_nullable
              as List<MapPageReviewModel>,
      recommendedCount: null == recommendedCount
          ? _self.recommendedCount
          : recommendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MapPageState].
extension MapPageStatePatterns on MapPageState {
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
    TResult Function(_MapPageState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapPageState() when $default != null:
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
    TResult Function(_MapPageState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPageState():
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
    TResult? Function(_MapPageState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPageState() when $default != null:
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
            MapPageStatus status,
            List<PopularPlace> popularPlaces,
            List<MapPageReviewModel> reviewModels,
            int recommendedCount,
            int reviewCount,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapPageState() when $default != null:
        return $default(_that.status, _that.popularPlaces, _that.reviewModels,
            _that.recommendedCount, _that.reviewCount, _that.errorMessage);
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
            MapPageStatus status,
            List<PopularPlace> popularPlaces,
            List<MapPageReviewModel> reviewModels,
            int recommendedCount,
            int reviewCount,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPageState():
        return $default(_that.status, _that.popularPlaces, _that.reviewModels,
            _that.recommendedCount, _that.reviewCount, _that.errorMessage);
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
            MapPageStatus status,
            List<PopularPlace> popularPlaces,
            List<MapPageReviewModel> reviewModels,
            int recommendedCount,
            int reviewCount,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapPageState() when $default != null:
        return $default(_that.status, _that.popularPlaces, _that.reviewModels,
            _that.recommendedCount, _that.reviewCount, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MapPageState implements MapPageState {
  const _MapPageState(
      {this.status = MapPageStatus.initial,
      final List<PopularPlace> popularPlaces = const <PopularPlace>[],
      final List<MapPageReviewModel> reviewModels =
          const <MapPageReviewModel>[],
      this.recommendedCount = 0,
      this.reviewCount = 0,
      this.errorMessage})
      : _popularPlaces = popularPlaces,
        _reviewModels = reviewModels;

  @override
  @JsonKey()
  final MapPageStatus status;
  final List<PopularPlace> _popularPlaces;
  @override
  @JsonKey()
  List<PopularPlace> get popularPlaces {
    if (_popularPlaces is EqualUnmodifiableListView) return _popularPlaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularPlaces);
  }

  final List<MapPageReviewModel> _reviewModels;
  @override
  @JsonKey()
  List<MapPageReviewModel> get reviewModels {
    if (_reviewModels is EqualUnmodifiableListView) return _reviewModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewModels);
  }

  @override
  @JsonKey()
  final int recommendedCount;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final String? errorMessage;

  /// Create a copy of MapPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MapPageStateCopyWith<_MapPageState> get copyWith =>
      __$MapPageStateCopyWithImpl<_MapPageState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MapPageState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._popularPlaces, _popularPlaces) &&
            const DeepCollectionEquality()
                .equals(other._reviewModels, _reviewModels) &&
            (identical(other.recommendedCount, recommendedCount) ||
                other.recommendedCount == recommendedCount) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_popularPlaces),
      const DeepCollectionEquality().hash(_reviewModels),
      recommendedCount,
      reviewCount,
      errorMessage);

  @override
  String toString() {
    return 'MapPageState(status: $status, popularPlaces: $popularPlaces, reviewModels: $reviewModels, recommendedCount: $recommendedCount, reviewCount: $reviewCount, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$MapPageStateCopyWith<$Res>
    implements $MapPageStateCopyWith<$Res> {
  factory _$MapPageStateCopyWith(
          _MapPageState value, $Res Function(_MapPageState) _then) =
      __$MapPageStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MapPageStatus status,
      List<PopularPlace> popularPlaces,
      List<MapPageReviewModel> reviewModels,
      int recommendedCount,
      int reviewCount,
      String? errorMessage});
}

/// @nodoc
class __$MapPageStateCopyWithImpl<$Res>
    implements _$MapPageStateCopyWith<$Res> {
  __$MapPageStateCopyWithImpl(this._self, this._then);

  final _MapPageState _self;
  final $Res Function(_MapPageState) _then;

  /// Create a copy of MapPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? popularPlaces = null,
    Object? reviewModels = null,
    Object? recommendedCount = null,
    Object? reviewCount = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_MapPageState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MapPageStatus,
      popularPlaces: null == popularPlaces
          ? _self._popularPlaces
          : popularPlaces // ignore: cast_nullable_to_non_nullable
              as List<PopularPlace>,
      reviewModels: null == reviewModels
          ? _self._reviewModels
          : reviewModels // ignore: cast_nullable_to_non_nullable
              as List<MapPageReviewModel>,
      recommendedCount: null == recommendedCount
          ? _self.recommendedCount
          : recommendedCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
