import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_request_dto.freezed.dart';
part 'change_password_request_dto.g.dart';

@freezed
abstract class ChangePasswordRequestDto with _$ChangePasswordRequestDto {
  const factory ChangePasswordRequestDto({
    required String email,
    required String verifiedToken,
    required String newPassword,
  }) = _ChangePasswordRequestDto;

  factory ChangePasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
