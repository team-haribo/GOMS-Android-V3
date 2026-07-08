// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'direction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DirectionState {
  DirectionStatus get status;
  String get departure;
  String get destination;
  List<RouteOption> get routeOptions;
  int get selectedRouteIndex;
  String? get errorMessage;

  /// Create a copy of DirectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DirectionStateCopyWith<DirectionState> get copyWith =>
      _$DirectionStateCopyWithImpl<DirectionState>(
          this as DirectionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DirectionState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.departure, departure) ||
                other.departure == departure) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            const DeepCollectionEquality()
                .equals(other.routeOptions, routeOptions) &&
            (identical(other.selectedRouteIndex, selectedRouteIndex) ||
                other.selectedRouteIndex == selectedRouteIndex) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      departure,
      destination,
      const DeepCollectionEquality().hash(routeOptions),
      selectedRouteIndex,
      errorMessage);

  @override
  String toString() {
    return 'DirectionState(status: $status, departure: $departure, destination: $destination, routeOptions: $routeOptions, selectedRouteIndex: $selectedRouteIndex, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $DirectionStateCopyWith<$Res> {
  factory $DirectionStateCopyWith(
          DirectionState value, $Res Function(DirectionState) _then) =
      _$DirectionStateCopyWithImpl;
  @useResult
  $Res call(
      {DirectionStatus status,
      String departure,
      String destination,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      String? errorMessage});
}

/// @nodoc
class _$DirectionStateCopyWithImpl<$Res>
    implements $DirectionStateCopyWith<$Res> {
  _$DirectionStateCopyWithImpl(this._self, this._then);

  final DirectionState _self;
  final $Res Function(DirectionState) _then;

  /// Create a copy of DirectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? departure = null,
    Object? destination = null,
    Object? routeOptions = null,
    Object? selectedRouteIndex = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DirectionStatus,
      departure: null == departure
          ? _self.departure
          : departure // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      routeOptions: null == routeOptions
          ? _self.routeOptions
          : routeOptions // ignore: cast_nullable_to_non_nullable
              as List<RouteOption>,
      selectedRouteIndex: null == selectedRouteIndex
          ? _self.selectedRouteIndex
          : selectedRouteIndex // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DirectionState].
extension DirectionStatePatterns on DirectionState {
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
    TResult Function(_DirectionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DirectionState() when $default != null:
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
    TResult Function(_DirectionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectionState():
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
    TResult? Function(_DirectionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectionState() when $default != null:
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
            DirectionStatus status,
            String departure,
            String destination,
            List<RouteOption> routeOptions,
            int selectedRouteIndex,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DirectionState() when $default != null:
        return $default(_that.status, _that.departure, _that.destination,
            _that.routeOptions, _that.selectedRouteIndex, _that.errorMessage);
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
            DirectionStatus status,
            String departure,
            String destination,
            List<RouteOption> routeOptions,
            int selectedRouteIndex,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectionState():
        return $default(_that.status, _that.departure, _that.destination,
            _that.routeOptions, _that.selectedRouteIndex, _that.errorMessage);
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
            DirectionStatus status,
            String departure,
            String destination,
            List<RouteOption> routeOptions,
            int selectedRouteIndex,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DirectionState() when $default != null:
        return $default(_that.status, _that.departure, _that.destination,
            _that.routeOptions, _that.selectedRouteIndex, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DirectionState implements DirectionState {
  const _DirectionState(
      {this.status = DirectionStatus.initial,
      this.departure = '',
      this.destination = '',
      final List<RouteOption> routeOptions = const <RouteOption>[],
      this.selectedRouteIndex = 0,
      this.errorMessage})
      : _routeOptions = routeOptions;

  @override
  @JsonKey()
  final DirectionStatus status;
  @override
  @JsonKey()
  final String departure;
  @override
  @JsonKey()
  final String destination;
  final List<RouteOption> _routeOptions;
  @override
  @JsonKey()
  List<RouteOption> get routeOptions {
    if (_routeOptions is EqualUnmodifiableListView) return _routeOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routeOptions);
  }

  @override
  @JsonKey()
  final int selectedRouteIndex;
  @override
  final String? errorMessage;

  /// Create a copy of DirectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DirectionStateCopyWith<_DirectionState> get copyWith =>
      __$DirectionStateCopyWithImpl<_DirectionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DirectionState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.departure, departure) ||
                other.departure == departure) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            const DeepCollectionEquality()
                .equals(other._routeOptions, _routeOptions) &&
            (identical(other.selectedRouteIndex, selectedRouteIndex) ||
                other.selectedRouteIndex == selectedRouteIndex) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      departure,
      destination,
      const DeepCollectionEquality().hash(_routeOptions),
      selectedRouteIndex,
      errorMessage);

  @override
  String toString() {
    return 'DirectionState(status: $status, departure: $departure, destination: $destination, routeOptions: $routeOptions, selectedRouteIndex: $selectedRouteIndex, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$DirectionStateCopyWith<$Res>
    implements $DirectionStateCopyWith<$Res> {
  factory _$DirectionStateCopyWith(
          _DirectionState value, $Res Function(_DirectionState) _then) =
      __$DirectionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DirectionStatus status,
      String departure,
      String destination,
      List<RouteOption> routeOptions,
      int selectedRouteIndex,
      String? errorMessage});
}

/// @nodoc
class __$DirectionStateCopyWithImpl<$Res>
    implements _$DirectionStateCopyWith<$Res> {
  __$DirectionStateCopyWithImpl(this._self, this._then);

  final _DirectionState _self;
  final $Res Function(_DirectionState) _then;

  /// Create a copy of DirectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? departure = null,
    Object? destination = null,
    Object? routeOptions = null,
    Object? selectedRouteIndex = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_DirectionState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as DirectionStatus,
      departure: null == departure
          ? _self.departure
          : departure // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _self.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      routeOptions: null == routeOptions
          ? _self._routeOptions
          : routeOptions // ignore: cast_nullable_to_non_nullable
              as List<RouteOption>,
      selectedRouteIndex: null == selectedRouteIndex
          ? _self.selectedRouteIndex
          : selectedRouteIndex // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
