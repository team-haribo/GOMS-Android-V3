import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_response_dto.freezed.dart';
part 'signin_response_dto.g.dart';

@freezed
abstract class SignInResponseDto with _$SignInResponseDto {
  const factory SignInResponseDto({
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenExpiresIn,
    required DateTime refreshTokenExpiresIn,
  }) = _SignInResponseDto;

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
