// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_outing_students_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchOutingStudentsResponse {
  List<OutingStudentResponse> get students;

  /// Create a copy of SearchOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchOutingStudentsResponseCopyWith<SearchOutingStudentsResponse>
      get copyWith => _$SearchOutingStudentsResponseCopyWithImpl<
              SearchOutingStudentsResponse>(
          this as SearchOutingStudentsResponse, _$identity);

  /// Serializes this SearchOutingStudentsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchOutingStudentsResponse &&
            const DeepCollectionEquality().equals(other.students, students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(students));

  @override
  String toString() {
    return 'SearchOutingStudentsResponse(students: $students)';
  }
}

/// @nodoc
abstract mixin class $SearchOutingStudentsResponseCopyWith<$Res> {
  factory $SearchOutingStudentsResponseCopyWith(
          SearchOutingStudentsResponse value,
          $Res Function(SearchOutingStudentsResponse) _then) =
      _$SearchOutingStudentsResponseCopyWithImpl;
  @useResult
  $Res call({List<OutingStudentResponse> students});
}

/// @nodoc
class _$SearchOutingStudentsResponseCopyWithImpl<$Res>
    implements $SearchOutingStudentsResponseCopyWith<$Res> {
  _$SearchOutingStudentsResponseCopyWithImpl(this._self, this._then);

  final SearchOutingStudentsResponse _self;
  final $Res Function(SearchOutingStudentsResponse) _then;

  /// Create a copy of SearchOutingStudentsResponse
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

/// Adds pattern-matching-related methods to [SearchOutingStudentsResponse].
extension SearchOutingStudentsResponsePatterns on SearchOutingStudentsResponse {
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
    TResult Function(_SearchOutingStudentsResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchOutingStudentsResponse() when $default != null:
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
    TResult Function(_SearchOutingStudentsResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchOutingStudentsResponse():
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
    TResult? Function(_SearchOutingStudentsResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchOutingStudentsResponse() when $default != null:
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
      case _SearchOutingStudentsResponse() when $default != null:
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
      case _SearchOutingStudentsResponse():
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
      case _SearchOutingStudentsResponse() when $default != null:
        return $default(_that.students);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchOutingStudentsResponse implements SearchOutingStudentsResponse {
  const _SearchOutingStudentsResponse(
      {required final List<OutingStudentResponse> students})
      : _students = students;
  factory _SearchOutingStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchOutingStudentsResponseFromJson(json);

  final List<OutingStudentResponse> _students;
  @override
  List<OutingStudentResponse> get students {
    if (_students is EqualUnmodifiableListView) return _students;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_students);
  }

  /// Create a copy of SearchOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchOutingStudentsResponseCopyWith<_SearchOutingStudentsResponse>
      get copyWith => __$SearchOutingStudentsResponseCopyWithImpl<
          _SearchOutingStudentsResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchOutingStudentsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchOutingStudentsResponse &&
            const DeepCollectionEquality().equals(other._students, _students));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_students));

  @override
  String toString() {
    return 'SearchOutingStudentsResponse(students: $students)';
  }
}

/// @nodoc
abstract mixin class _$SearchOutingStudentsResponseCopyWith<$Res>
    implements $SearchOutingStudentsResponseCopyWith<$Res> {
  factory _$SearchOutingStudentsResponseCopyWith(
          _SearchOutingStudentsResponse value,
          $Res Function(_SearchOutingStudentsResponse) _then) =
      __$SearchOutingStudentsResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<OutingStudentResponse> students});
}

/// @nodoc
class __$SearchOutingStudentsResponseCopyWithImpl<$Res>
    implements _$SearchOutingStudentsResponseCopyWith<$Res> {
  __$SearchOutingStudentsResponseCopyWithImpl(this._self, this._then);

  final _SearchOutingStudentsResponse _self;
  final $Res Function(_SearchOutingStudentsResponse) _then;

  /// Create a copy of SearchOutingStudentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? students = null,
  }) {
    return _then(_SearchOutingStudentsResponse(
      students: null == students
          ? _self._students
          : students // ignore: cast_nullable_to_non_nullable
              as List<OutingStudentResponse>,
    ));
  }
}

// dart format on
