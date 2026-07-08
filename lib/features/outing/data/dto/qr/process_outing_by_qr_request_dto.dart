import 'package:freezed_annotation/freezed_annotation.dart';

part 'process_outing_by_qr_request_dto.freezed.dart';
part 'process_outing_by_qr_request_dto.g.dart';

@freezed
abstract class ProcessOutingByQrRequestDto with _$ProcessOutingByQrRequestDto {
  const factory ProcessOutingByQrRequestDto({
    required String uuid,
    required int exp,
  }) = _ProcessOutingByQrRequestDto;

  factory ProcessOutingByQrRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProcessOutingByQrRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
