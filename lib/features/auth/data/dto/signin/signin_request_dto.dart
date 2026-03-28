import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_request_dto.freezed.dart';
part 'signin_request_dto.g.dart';

@freezed
abstract class SignInRequestDto with _$SignInRequestDto {
  const factory SignInRequestDto({
    required String email,
    required String password,
  }) = _SignInRequestDto;

  factory SignInRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
