// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_outing_students_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurrentOutingStudentsResponse {
  List<OutingStudentResponse> get students;

  /// Create a copy of CurrentOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CurrentOutingStudentsResponseCopyWith<CurrentOutingStudentsResponse>
      get copyWith => _$CurrentOutingStudentsResponseCopyWithImpl<
              CurrentOutingStudentsResponse>(
          this as CurrentOutingStudentsResponse, _$identity);

  /// Serializes this CurrentOutingStudentsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CurrentOutingStudentsResponse &&
            const DeepCollectionEquality().equals(other.students, students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(students));

  @override
  String toString() {
    return 'CurrentOutingStudentsResponse(students: $students)';
  }
}

/// @nodoc
abstract mixin class $CurrentOutingStudentsResponseCopyWith<$Res> {
  factory $CurrentOutingStudentsResponseCopyWith(
          CurrentOutingStudentsResponse value,
          $Res Function(CurrentOutingStudentsResponse) _then) =
      _$CurrentOutingStudentsResponseCopyWithImpl;
  @useResult
  $Res call({List<OutingStudentResponse> students});
}

/// @nodoc
class _$CurrentOutingStudentsResponseCopyWithImpl<$Res>
    implements $CurrentOutingStudentsResponseCopyWith<$Res> {
  _$CurrentOutingStudentsResponseCopyWithImpl(this._self, this._then);

  final CurrentOutingStudentsResponse _self;
  final $Res Function(CurrentOutingStudentsResponse) _then;

  /// Create a copy of CurrentOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? students = null,
  }) {
    return _then(_self.copyWith(
      students: null == students
          ? _self.students
          : students // ignore: cast_nullable_to_non_nullable
              as List<OutingStudentResponse>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CurrentOutingStudentsResponse].
extension CurrentOutingStudentsResponsePatterns
    on CurrentOutingStudentsResponse {
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
    TResult Function(_CurrentOutingStudentsResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse() when $default != null:
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
    TResult Function(_CurrentOutingStudentsResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse():
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
    TResult? Function(_CurrentOutingStudentsResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse() when $default != null:
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
    TResult Function(List<OutingStudentResponse> students)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse() when $default != null:
        return $default(_that.students);
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
    TResult Function(List<OutingStudentResponse> students) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse():
        return $default(_that.students);
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
    TResult? Function(List<OutingStudentResponse> students)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CurrentOutingStudentsResponse() when $default != null:
        return $default(_that.students);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CurrentOutingStudentsResponse implements CurrentOutingStudentsResponse {
  const _CurrentOutingStudentsResponse(
      {required final List<OutingStudentResponse> students})
      : _students = students;
  factory _CurrentOutingStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentOutingStudentsResponseFromJson(json);

  final List<OutingStudentResponse> _students;
  @override
  List<OutingStudentResponse> get students {
    if (_students is EqualUnmodifiableListView) return _students;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_students);
  }

  /// Create a copy of CurrentOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CurrentOutingStudentsResponseCopyWith<_CurrentOutingStudentsResponse>
      get copyWith => __$CurrentOutingStudentsResponseCopyWithImpl<
          _CurrentOutingStudentsResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CurrentOutingStudentsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CurrentOutingStudentsResponse &&
            const DeepCollectionEquality().equals(other._students, _students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_students));

  @override
  String toString() {
    return 'CurrentOutingStudentsResponse(students: $students)';
  }
}

/// @nodoc
abstract mixin class _$CurrentOutingStudentsResponseCopyWith<$Res>
    implements $CurrentOutingStudentsResponseCopyWith<$Res> {
  factory _$CurrentOutingStudentsResponseCopyWith(
          _CurrentOutingStudentsResponse value,
          $Res Function(_CurrentOutingStudentsResponse) _then) =
      __$CurrentOutingStudentsResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<OutingStudentResponse> students});
}

/// @nodoc
class __$CurrentOutingStudentsResponseCopyWithImpl<$Res>
    implements _$CurrentOutingStudentsResponseCopyWith<$Res> {
  __$CurrentOutingStudentsResponseCopyWithImpl(this._self, this._then);

  final _CurrentOutingStudentsResponse _self;
  final $Res Function(_CurrentOutingStudentsResponse) _then;

  /// Create a copy of CurrentOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? students = null,
  }) {
    return _then(_CurrentOutingStudentsResponse(
      students: null == students
          ? _self._students
          : students // ignore: cast_nullable_to_non_nullable
              as List<OutingStudentResponse>,
    ));
  }
}

// dart format on
