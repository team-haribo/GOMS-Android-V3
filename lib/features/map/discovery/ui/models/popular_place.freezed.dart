// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PopularPlace {
  int? get placeId;
  String get name;
  String get category;
  String get address;
  int get review;
  int get recommended;
  bool get isRecommended;
  int? get distanceMeters;
  MapCoordinate get coordinate;

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PopularPlaceCopyWith<PopularPlace> get copyWith =>
      _$PopularPlaceCopyWithImpl<PopularPlace>(
          this as PopularPlace, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PopularPlace &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.recommended, recommended) ||
                other.recommended == recommended) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.coordinate, coordinate) ||
                other.coordinate == coordinate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, name, category, address,
      review, recommended, isRecommended, distanceMeters, coordinate);

  @override
  String toString() {
    return 'PopularPlace(placeId: $placeId, name: $name, category: $category, address: $address, review: $review, recommended: $recommended, isRecommended: $isRecommended, distanceMeters: $distanceMeters, coordinate: $coordinate)';
  }
}

/// @nodoc
abstract mixin class $PopularPlaceCopyWith<$Res> {
  factory $PopularPlaceCopyWith(
          PopularPlace value, $Res Function(PopularPlace) _then) =
      _$PopularPlaceCopyWithImpl;
  @useResult
  $Res call(
      {int? placeId,
      String name,
      String category,
      String address,
      int review,
      int recommended,
      bool isRecommended,
      int? distanceMeters,
      MapCoordinate coordinate});

  $MapCoordinateCopyWith<$Res> get coordinate;
}

/// @nodoc
class _$PopularPlaceCopyWithImpl<$Res> implements $PopularPlaceCopyWith<$Res> {
  _$PopularPlaceCopyWithImpl(this._self, this._then);

  final PopularPlace _self;
  final $Res Function(PopularPlace) _then;

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = freezed,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? review = null,
    Object? recommended = null,
    Object? isRecommended = null,
    Object? distanceMeters = freezed,
    Object? coordinate = null,
  }) {
    return _then(_self.copyWith(
      placeId: freezed == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      review: null == review
          ? _self.review
          : review // ignore: cast_nullable_to_non_nullable
              as int,
      recommended: null == recommended
          ? _self.recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as int,
      isRecommended: null == isRecommended
          ? _self.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceMeters: freezed == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      coordinate: null == coordinate
          ? _self.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as MapCoordinate,
    ));
  }

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapCoordinateCopyWith<$Res> get coordinate {
    return $MapCoordinateCopyWith<$Res>(_self.coordinate, (value) {
      return _then(_self.copyWith(coordinate: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PopularPlace].
extension PopularPlacePatterns on PopularPlace {
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
    TResult Function(_PopularPlace value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PopularPlace() when $default != null:
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
    TResult Function(_PopularPlace value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PopularPlace():
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
    TResult? Function(_PopularPlace value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PopularPlace() when $default != null:
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
            int? placeId,
            String name,
            String category,
            String address,
            int review,
            int recommended,
            bool isRecommended,
            int? distanceMeters,
            MapCoordinate coordinate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PopularPlace() when $default != null:
        return $default(
            _that.placeId,
            _that.name,
            _that.category,
            _that.address,
            _that.review,
            _that.recommended,
            _that.isRecommended,
            _that.distanceMeters,
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
            int? placeId,
            String name,
            String category,
            String address,
            int review,
            int recommended,
            bool isRecommended,
            int? distanceMeters,
            MapCoordinate coordinate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PopularPlace():
        return $default(
            _that.placeId,
            _that.name,
            _that.category,
            _that.address,
            _that.review,
            _that.recommended,
            _that.isRecommended,
            _that.distanceMeters,
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
            int? placeId,
            String name,
            String category,
            String address,
            int review,
            int recommended,
            bool isRecommended,
            int? distanceMeters,
            MapCoordinate coordinate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PopularPlace() when $default != null:
        return $default(
            _that.placeId,
            _that.name,
            _that.category,
            _that.address,
            _that.review,
            _that.recommended,
            _that.isRecommended,
            _that.distanceMeters,
            _that.coordinate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PopularPlace implements PopularPlace {
  const _PopularPlace(
      {this.placeId,
      required this.name,
      required this.category,
      required this.address,
      required this.review,
      required this.recommended,
      this.isRecommended = false,
      this.distanceMeters,
      required this.coordinate});

  @override
  final int? placeId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String address;
  @override
  final int review;
  @override
  final int recommended;
  @override
  @JsonKey()
  final bool isRecommended;
  @override
  final int? distanceMeters;
  @override
  final MapCoordinate coordinate;

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PopularPlaceCopyWith<_PopularPlace> get copyWith =>
      __$PopularPlaceCopyWithImpl<_PopularPlace>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PopularPlace &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.recommended, recommended) ||
                other.recommended == recommended) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.coordinate, coordinate) ||
                other.coordinate == coordinate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, name, category, address,
      review, recommended, isRecommended, distanceMeters, coordinate);

  @override
  String toString() {
    return 'PopularPlace(placeId: $placeId, name: $name, category: $category, address: $address, review: $review, recommended: $recommended, isRecommended: $isRecommended, distanceMeters: $distanceMeters, coordinate: $coordinate)';
  }
}

/// @nodoc
abstract mixin class _$PopularPlaceCopyWith<$Res>
    implements $PopularPlaceCopyWith<$Res> {
  factory _$PopularPlaceCopyWith(
          _PopularPlace value, $Res Function(_PopularPlace) _then) =
      __$PopularPlaceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? placeId,
      String name,
      String category,
      String address,
      int review,
      int recommended,
      bool isRecommended,
      int? distanceMeters,
      MapCoordinate coordinate});

  @override
  $MapCoordinateCopyWith<$Res> get coordinate;
}

/// @nodoc
class __$PopularPlaceCopyWithImpl<$Res>
    implements _$PopularPlaceCopyWith<$Res> {
  __$PopularPlaceCopyWithImpl(this._self, this._then);

  final _PopularPlace _self;
  final $Res Function(_PopularPlace) _then;

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? placeId = freezed,
    Object? name = null,
    Object? category = null,
    Object? address = null,
    Object? review = null,
    Object? recommended = null,
    Object? isRecommended = null,
    Object? distanceMeters = freezed,
    Object? coordinate = null,
  }) {
    return _then(_PopularPlace(
      placeId: freezed == placeId
          ? _self.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      review: null == review
          ? _self.review
          : review // ignore: cast_nullable_to_non_nullable
              as int,
      recommended: null == recommended
          ? _self.recommended
          : recommended // ignore: cast_nullable_to_non_nullable
              as int,
      isRecommended: null == isRecommended
          ? _self.isRecommended
          : isRecommended // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceMeters: freezed == distanceMeters
          ? _self.distanceMeters
          : distanceMeters // ignore: cast_nullable_to_non_nullable
              as int?,
      coordinate: null == coordinate
          ? _self.coordinate
          : coordinate // ignore: cast_nullable_to_non_nullable
              as MapCoordinate,
    ));
  }

  /// Create a copy of PopularPlace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapCoordinateCopyWith<$Res> get coordinate {
    return $MapCoordinateCopyWith<$Res>(_self.coordinate, (value) {
      return _then(_self.copyWith(coordinate: value));
    });
  }
}

// dart format on
