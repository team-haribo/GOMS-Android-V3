import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/auth/signup/domain/enums/department_type.dart';
import 'package:goms/features/auth/signup/domain/enums/gender_type.dart';

part 'signup_request_dto.freezed.dart';
part 'signup_request_dto.g.dart';

@freezed
abstract class SignUpRequestDto with _$SignUpRequestDto {
  const factory SignUpRequestDto({
    required String email,
    required String verifiedToken,
    required String password,
    required String name,
    required int grade,
    required DepartmentType department,
    required GenderType gender,
  }) = _SignUpRequestDto;

  factory SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
