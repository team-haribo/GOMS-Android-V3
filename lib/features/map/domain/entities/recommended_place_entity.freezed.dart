// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommended_place_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecommendedPlaceEntity {
  int get placeId;
  int get reviewCount;
  int get recommendCount;
  bool get recommended;
  String? get placeName;
  String? get category;
  String? get address;
  MapCoordinate? get coordinate;

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecommendedPlaceEntityCopyWith<RecommendedPlaceEntity> get copyWith =>
      _$RecommendedPlaceEntityCopyWithImpl<RecommendedPlaceEntity>(
          this as RecommendedPlaceEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecommendedPlaceEntity &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.recommended, recommended) ||
                other.recommended == recommended) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.coordinate, coordinate) ||
                other.coordinate == coordinate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, reviewCount,
      recommendCount, recommended, placeName, category, address, coordinate);

  @override
  String toString() {
    return 'RecommendedPlaceEntity(placeId: $placeId, reviewCount: $reviewCount, recommendCount: $recommendCount, recommended: $recommended, placeName: $placeName, category: $category, address: $address, coordinate: $coordinate)';
  }
}

/// @nodoc
abstract mixin class $RecommendedPlaceEntityCopyWith<$Res> {
  factory $RecommendedPlaceEntityCopyWith(RecommendedPlaceEntity value,
          $Res Function(RecommendedPlaceEntity) _then) =
      _$RecommendedPlaceEntityCopyWithImpl;
  @useResult
  $Res call(
      {int placeId,
      int reviewCount,
      int recommendCount,
      bool recommended,
      String? placeName,
      String? category,
      String? address,
      MapCoordinate? coordinate});

  $MapCoordinateCopyWith<$Res>? get coordinate;
}

/// @nodoc
class _$RecommendedPlaceEntityCopyWithImpl<$Res>
    implements $RecommendedPlaceEntityCopyWith<$Res> {
  _$RecommendedPlaceEntityCopyWithImpl(this._self, this._then);

  final RecommendedPlaceEntity _self;
  final $Res Function(RecommendedPlaceEntity) _then;

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? reviewCount = null,
    Object? recommendCount = null,
    Object? recommended = null,
    Object? placeName = freezed,
    Object? category = freezed,
    Object? address = freezed,
    Object? coordinate = freezed,
  }) {
    return _then(_self.copyWith(
      placeId: null == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommended: null == recommended
          ? _self.recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as bool,
      placeName: freezed == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinate: freezed == coordinate
          ? _self.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as MapCoordinate?,
    ));
  }

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapCoordinateCopyWith<$Res>? get coordinate {
    if (_self.coordinate == null) {
      return null;
    }

    return $MapCoordinateCopyWith<$Res>(_self.coordinate!, (value) {
      return _then(_self.copyWith(coordinate: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RecommendedPlaceEntity].
extension RecommendedPlaceEntityPatterns on RecommendedPlaceEntity {
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
    TResult Function(_RecommendedPlaceEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity() when $default != null:
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
    TResult Function(_RecommendedPlaceEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity():
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
    TResult? Function(_RecommendedPlaceEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity() when $default != null:
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
            int placeId,
            int reviewCount,
            int recommendCount,
            bool recommended,
            String? placeName,
            String? category,
            String? address,
            MapCoordinate? coordinate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity() when $default != null:
        return $default(
            _that.placeId,
            _that.reviewCount,
            _that.recommendCount,
            _that.recommended,
            _that.placeName,
            _that.category,
            _that.address,
            _that.coordinate);
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
            int placeId,
            int reviewCount,
            int recommendCount,
            bool recommended,
            String? placeName,
            String? category,
            String? address,
            MapCoordinate? coordinate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity():
        return $default(
            _that.placeId,
            _that.reviewCount,
            _that.recommendCount,
            _that.recommended,
            _that.placeName,
            _that.category,
            _that.address,
            _that.coordinate);
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
            int placeId,
            int reviewCount,
            int recommendCount,
            bool recommended,
            String? placeName,
            String? category,
            String? address,
            MapCoordinate? coordinate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecommendedPlaceEntity() when $default != null:
        return $default(
            _that.placeId,
            _that.reviewCount,
            _that.recommendCount,
            _that.recommended,
            _that.placeName,
            _that.category,
            _that.address,
            _that.coordinate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RecommendedPlaceEntity implements RecommendedPlaceEntity {
  const _RecommendedPlaceEntity(
      {required this.placeId,
      required this.reviewCount,
      required this.recommendCount,
      required this.recommended,
      this.placeName,
      this.category,
      this.address,
      this.coordinate});

  @override
  final int placeId;
  @override
  final int reviewCount;
  @override
  final int recommendCount;
  @override
  final bool recommended;
  @override
  final String? placeName;
  @override
  final String? category;
  @override
  final String? address;
  @override
  final MapCoordinate? coordinate;

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecommendedPlaceEntityCopyWith<_RecommendedPlaceEntity> get copyWith =>
      __$RecommendedPlaceEntityCopyWithImpl<_RecommendedPlaceEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecommendedPlaceEntity &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.recommendCount, recommendCount) ||
                other.recommendCount == recommendCount) &&
            (identical(other.recommended, recommended) ||
                other.recommended == recommended) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.coordinate, coordinate) ||
                other.coordinate == coordinate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, reviewCount,
      recommendCount, recommended, placeName, category, address, coordinate);

  @override
  String toString() {
    return 'RecommendedPlaceEntity(placeId: $placeId, reviewCount: $reviewCount, recommendCount: $recommendCount, recommended: $recommended, placeName: $placeName, category: $category, address: $address, coordinate: $coordinate)';
  }
}

/// @nodoc
abstract mixin class _$RecommendedPlaceEntityCopyWith<$Res>
    implements $RecommendedPlaceEntityCopyWith<$Res> {
  factory _$RecommendedPlaceEntityCopyWith(_RecommendedPlaceEntity value,
          $Res Function(_RecommendedPlaceEntity) _then) =
      __$RecommendedPlaceEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int placeId,
      int reviewCount,
      int recommendCount,
      bool recommended,
      String? placeName,
      String? category,
      String? address,
      MapCoordinate? coordinate});

  @override
  $MapCoordinateCopyWith<$Res>? get coordinate;
}

/// @nodoc
class __$RecommendedPlaceEntityCopyWithImpl<$Res>
    implements _$RecommendedPlaceEntityCopyWith<$Res> {
  __$RecommendedPlaceEntityCopyWithImpl(this._self, this._then);

  final _RecommendedPlaceEntity _self;
  final $Res Function(_RecommendedPlaceEntity) _then;

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? placeId = null,
    Object? reviewCount = null,
    Object? recommendCount = null,
    Object? recommended = null,
    Object? placeName = freezed,
    Object? category = freezed,
    Object? address = freezed,
    Object? coordinate = freezed,
  }) {
    return _then(_RecommendedPlaceEntity(
      placeId: null == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommendCount: null == recommendCount
          ? _self.recommendCount
          : recommendCount // ignore: cast_nullable_to_non_nullable
              as int,
      recommended: null == recommended
          ? _self.recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as bool,
      placeName: freezed == placeName
          ? _self.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinate: freezed == coordinate
          ? _self.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as MapCoordinate?,
    ));
  }

  /// Create a copy of RecommendedPlaceEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapCoordinateCopyWith<$Res>? get coordinate {
    if (_self.coordinate == null) {
      return null;
    }

    return $MapCoordinateCopyWith<$Res>(_self.coordinate!, (value) {
      return _then(_self.copyWith(coordinate: value));
    });
  }
}

// dart format on
