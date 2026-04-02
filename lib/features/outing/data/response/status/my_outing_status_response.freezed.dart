// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_outing_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyOutingStatusResponse {
  int get memberId;
  String get status;
  String get name;
  int get grade;
  String get department;

  /// Create a copy of MyOutingStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyOutingStatusResponseCopyWith<MyOutingStatusResponse> get copyWith =>
      _$MyOutingStatusResponseCopyWithImpl<MyOutingStatusResponse>(
          this as MyOutingStatusResponse, _$identity);

  /// Serializes this MyOutingStatusResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyOutingStatusResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, status, name, grade, department);

  @override
  String toString() {
    return 'MyOutingStatusResponse(memberId: $memberId, status: $status, name: $name, grade: $grade, department: $department)';
  }
}

/// @nodoc
abstract mixin class $MyOutingStatusResponseCopyWith<$Res> {
  factory $MyOutingStatusResponseCopyWith(MyOutingStatusResponse value,
          $Res Function(MyOutingStatusResponse) _then) =
      _$MyOutingStatusResponseCopyWithImpl;
  @useResult
  $Res call(
      {int memberId, String status, String name, int grade, String department});
}

/// @nodoc
class _$MyOutingStatusResponseCopyWithImpl<$Res>
    implements $MyOutingStatusResponseCopyWith<$Res> {
  _$MyOutingStatusResponseCopyWithImpl(this._self, this._then);

  final MyOutingStatusResponse _self;
  final $Res Function(MyOutingStatusResponse) _then;

  /// Create a copy of MyOutingStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? status = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
  }) {
    return _then(_self.copyWith(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [MyOutingStatusResponse].
extension MyOutingStatusResponsePatterns on MyOutingStatusResponse {
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
    TResult Function(_MyOutingStatusResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse() when $default != null:
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
    TResult Function(_MyOutingStatusResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse():
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
    TResult? Function(_MyOutingStatusResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse() when $default != null:
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
    TResult Function(int memberId, String status, String name, int grade,
            String department)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse() when $default != null:
        return $default(_that.memberId, _that.status, _that.name, _that.grade,
            _that.department);
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
    TResult Function(int memberId, String status, String name, int grade,
            String department)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse():
        return $default(_that.memberId, _that.status, _that.name, _that.grade,
            _that.department);
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
    TResult? Function(int memberId, String status, String name, int grade,
            String department)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyOutingStatusResponse() when $default != null:
        return $default(_that.memberId, _that.status, _that.name, _that.grade,
            _that.department);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MyOutingStatusResponse implements MyOutingStatusResponse {
  const _MyOutingStatusResponse(
      {required this.memberId,
      required this.status,
      required this.name,
      required this.grade,
      required this.department});
  factory _MyOutingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOutingStatusResponseFromJson(json);

  @override
  final int memberId;
  @override
  final String status;
  @override
  final String name;
  @override
  final int grade;
  @override
  final String department;

  /// Create a copy of MyOutingStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyOutingStatusResponseCopyWith<_MyOutingStatusResponse> get copyWith =>
      __$MyOutingStatusResponseCopyWithImpl<_MyOutingStatusResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MyOutingStatusResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyOutingStatusResponse &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.department, department) ||
                other.department == department));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, status, name, grade, department);

  @override
  String toString() {
    return 'MyOutingStatusResponse(memberId: $memberId, status: $status, name: $name, grade: $grade, department: $department)';
  }
}

/// @nodoc
abstract mixin class _$MyOutingStatusResponseCopyWith<$Res>
    implements $MyOutingStatusResponseCopyWith<$Res> {
  factory _$MyOutingStatusResponseCopyWith(_MyOutingStatusResponse value,
          $Res Function(_MyOutingStatusResponse) _then) =
      __$MyOutingStatusResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int memberId, String status, String name, int grade, String department});
}

/// @nodoc
class __$MyOutingStatusResponseCopyWithImpl<$Res>
    implements _$MyOutingStatusResponseCopyWith<$Res> {
  __$MyOutingStatusResponseCopyWithImpl(this._self, this._then);

  final _MyOutingStatusResponse _self;
  final $Res Function(_MyOutingStatusResponse) _then;

  /// Create a copy of MyOutingStatusResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? memberId = null,
    Object? status = null,
    Object? name = null,
    Object? grade = null,
    Object? department = null,
  }) {
    return _then(_MyOutingStatusResponse(
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

// dart format on
