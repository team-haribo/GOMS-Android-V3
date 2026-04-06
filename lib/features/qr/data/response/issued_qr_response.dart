import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';

part 'issued_qr_response.freezed.dart';
part 'issued_qr_response.g.dart';

@freezed
abstract class IssuedQrResponse with _$IssuedQrResponse {
  const factory IssuedQrResponse({
    required String uuid,
    required int exp,
  }) = _IssuedQrResponse;

  factory IssuedQrResponse.fromJson(Map<String, dynamic> json) =>
      _$IssuedQrResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension IssuedQrResponseX on IssuedQrResponse {
  IssuedQrEntity toEntity() {
    return IssuedQrEntity(
      uuid: uuid,
      exp: exp,
      issuedAt: DateTime.now(),
    );
  }
}
