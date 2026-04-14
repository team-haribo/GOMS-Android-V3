// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_screen_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapScreenUiState {
  bool get isSdkReady;
  bool get isFetchingRoute;

  /// Create a copy of MapScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapScreenUiStateCopyWith<MapScreenUiState> get copyWith =>
      _$MapScreenUiStateCopyWithImpl<MapScreenUiState>(
          this as MapScreenUiState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapScreenUiState &&
            (identical(other.isSdkReady, isSdkReady) ||
                other.isSdkReady == isSdkReady) &&
            (identical(other.isFetchingRoute, isFetchingRoute) ||
                other.isFetchingRoute == isFetchingRoute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSdkReady, isFetchingRoute);

  @override
  String toString() {
    return 'MapScreenUiState(isSdkReady: $isSdkReady, isFetchingRoute: $isFetchingRoute)';
  }
}

/// @nodoc
abstract mixin class $MapScreenUiStateCopyWith<$Res> {
  factory $MapScreenUiStateCopyWith(
          MapScreenUiState value, $Res Function(MapScreenUiState) _then) =
      _$MapScreenUiStateCopyWithImpl;
  @useResult
  $Res call({bool isSdkReady, bool isFetchingRoute});
}

/// @nodoc
class _$MapScreenUiStateCopyWithImpl<$Res>
    implements $MapScreenUiStateCopyWith<$Res> {
  _$MapScreenUiStateCopyWithImpl(this._self, this._then);

  final MapScreenUiState _self;
  final $Res Function(MapScreenUiState) _then;

  /// Create a copy of MapScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSdkReady = null,
    Object? isFetchingRoute = null,
  }) {
    return _then(_self.copyWith(
      isSdkReady: null == isSdkReady
          ? _self.isSdkReady
          : isSdkReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isFetchingRoute: null == isFetchingRoute
          ? _self.isFetchingRoute
          : isFetchingRoute // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MapScreenUiState].
extension MapScreenUiStatePatterns on MapScreenUiState {
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
    TResult Function(_MapScreenUiState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState() when $default != null:
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
    TResult Function(_MapScreenUiState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState():
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
    TResult? Function(_MapScreenUiState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState() when $default != null:
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
    TResult Function(bool isSdkReady, bool isFetchingRoute)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState() when $default != null:
        return $default(_that.isSdkReady, _that.isFetchingRoute);
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
    TResult Function(bool isSdkReady, bool isFetchingRoute) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState():
        return $default(_that.isSdkReady, _that.isFetchingRoute);
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
    TResult? Function(bool isSdkReady, bool isFetchingRoute)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MapScreenUiState() when $default != null:
        return $default(_that.isSdkReady, _that.isFetchingRoute);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MapScreenUiState implements MapScreenUiState {
  const _MapScreenUiState(
      {this.isSdkReady = false, this.isFetchingRoute = false});

  @override
  @JsonKey()
  final bool isSdkReady;
  @override
  @JsonKey()
  final bool isFetchingRoute;

  /// Create a copy of MapScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MapScreenUiStateCopyWith<_MapScreenUiState> get copyWith =>
      __$MapScreenUiStateCopyWithImpl<_MapScreenUiState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MapScreenUiState &&
            (identical(other.isSdkReady, isSdkReady) ||
                other.isSdkReady == isSdkReady) &&
            (identical(other.isFetchingRoute, isFetchingRoute) ||
                other.isFetchingRoute == isFetchingRoute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSdkReady, isFetchingRoute);

  @override
  String toString() {
    return 'MapScreenUiState(isSdkReady: $isSdkReady, isFetchingRoute: $isFetchingRoute)';
  }
}

/// @nodoc
abstract mixin class _$MapScreenUiStateCopyWith<$Res>
    implements $MapScreenUiStateCopyWith<$Res> {
  factory _$MapScreenUiStateCopyWith(
          _MapScreenUiState value, $Res Function(_MapScreenUiState) _then) =
      __$MapScreenUiStateCopyWithImpl;
  @override
  @useResult
  $Res call({bool isSdkReady, bool isFetchingRoute});
}

/// @nodoc
class __$MapScreenUiStateCopyWithImpl<$Res>
    implements _$MapScreenUiStateCopyWith<$Res> {
  __$MapScreenUiStateCopyWithImpl(this._self, this._then);

  final _MapScreenUiState _self;
  final $Res Function(_MapScreenUiState) _then;

  /// Create a copy of MapScreenUiState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isSdkReady = null,
    Object? isFetchingRoute = null,
  }) {
    return _then(_MapScreenUiState(
      isSdkReady: null == isSdkReady
          ? _self.isSdkReady
          : isSdkReady // ignore: cast_nullable_to_non_nullable
              as bool,
      isFetchingRoute: null == isFetchingRoute
          ? _self.isFetchingRoute
          : isFetchingRoute // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
