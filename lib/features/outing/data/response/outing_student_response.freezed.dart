// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outing_student_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutingStudentResponse {
  int get memberId;
  String get name;
  int get grade;
  String get department;
  DateTime get outingAt;

  /// Create a copy of OutingStudentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OutingStudentResponseCopyWith<OutingStudentResponse> get copyWith =>
      _$OutingStudentResponseCopyWithImpl<OutingStudentResponse>(
          this as OutingStudentResponse, _$identity);

  /// Serializes this OutingStudentResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OutingStudentResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.outingAt, outingAt) ||
                other.outingAt == outingAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, name, grade, department, outingAt);

  @override
  String toString() {
    return 'OutingStudentResponse(memberId: $memberId, name: $name, grade: $grade, department: $department, outingAt: $outingAt)';
  }
}

/// @nodoc
abstract mixin class $OutingStudentResponseCopyWith<$Res> {
  factory $OutingStudentResponseCopyWith(OutingStudentResponse value,
          $Res Function(OutingStudentResponse) _then) =
      _$OutingStudentResponseCopyWithImpl;
  @useResult
  $Res call(
      {int memberId,
      String name,
      int grade,
      String department,
      DateTime outingAt});
}

/// @nodoc
class _$OutingStudentResponseCopyWithImpl<$Res>
    implements $OutingStudentResponseCopyWith<$Res> {
  _$OutingStudentResponseCopyWithImpl(this._self, this._then);

  final OutingStudentResponse _self;
  final $Res Function(OutingStudentResponse) _then;

  /// Create a copy of OutingStudentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? outingAt = null,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      outingAt: null == outingAt
          ? _self.outingAt
          : outingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [OutingStudentResponse].
extension OutingStudentResponsePatterns on OutingStudentResponse {
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
    TResult Function(_OutingStudentResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse() when $default != null:
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
    TResult Function(_OutingStudentResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse():
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
    TResult? Function(_OutingStudentResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse() when $default != null:
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
    TResult Function(int memberId, String name, int grade, String department,
            DateTime outingAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse() when $default != null:
        return $default(_that.memberId, _that.name, _that.grade,
            _that.department, _that.outingAt);
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
    TResult Function(int memberId, String name, int grade, String department,
            DateTime outingAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse():
        return $default(_that.memberId, _that.name, _that.grade,
            _that.department, _that.outingAt);
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
    TResult? Function(int memberId, String name, int grade, String department,
            DateTime outingAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutingStudentResponse() when $default != null:
        return $default(_that.memberId, _that.name, _that.grade,
            _that.department, _that.outingAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OutingStudentResponse implements OutingStudentResponse {
  const _OutingStudentResponse(
      {required this.memberId,
      required this.name,
      required this.grade,
      required this.department,
      required this.outingAt});
  factory _OutingStudentResponse.fromJson(Map<String, dynamic> json) =>
      _$OutingStudentResponseFromJson(json);

  @override
  final int memberId;
  @override
  final String name;
  @override
  final int grade;
  @override
  final String department;
  @override
  final DateTime outingAt;

  /// Create a copy of OutingStudentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OutingStudentResponseCopyWith<_OutingStudentResponse> get copyWith =>
      __$OutingStudentResponseCopyWithImpl<_OutingStudentResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OutingStudentResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OutingStudentResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.outingAt, outingAt) ||
                other.outingAt == outingAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, name, grade, department, outingAt);

  @override
  String toString() {
    return 'OutingStudentResponse(memberId: $memberId, name: $name, grade: $grade, department: $department, outingAt: $outingAt)';
  }
}

/// @nodoc
abstract mixin class _$OutingStudentResponseCopyWith<$Res>
    implements $OutingStudentResponseCopyWith<$Res> {
  factory _$OutingStudentResponseCopyWith(_OutingStudentResponse value,
          $Res Function(_OutingStudentResponse) _then) =
      __$OutingStudentResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId,
      String name,
      int grade,
      String department,
      DateTime outingAt});
}

/// @nodoc
class __$OutingStudentResponseCopyWithImpl<$Res>
    implements _$OutingStudentResponseCopyWith<$Res> {
  __$OutingStudentResponseCopyWithImpl(this._self, this._then);

  final _OutingStudentResponse _self;
  final $Res Function(_OutingStudentResponse) _then;

  /// Create a copy of OutingStudentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
    Object? outingAt = null,
  }) {
    return _then(_OutingStudentResponse(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      grade: null == grade
          ? _self.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      department: null == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      outingAt: null == outingAt
          ? _self.outingAt
          : outingAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
