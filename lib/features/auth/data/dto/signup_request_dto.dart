import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String department,
    required String gender,
  }) = _SignUpRequestDto;

  factory SignUpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
