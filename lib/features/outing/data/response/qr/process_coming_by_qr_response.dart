import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/domain/entities/outing_coming_qr_result_entity.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

part 'process_coming_by_qr_response.freezed.dart';
part 'process_coming_by_qr_response.g.dart';

@freezed
abstract class ProcessComingByQrResponse with _$ProcessComingByQrResponse {
  const factory ProcessComingByQrResponse({
    required OutingAction action,
    required int outingId,
    required OutingStatusType status,
    required DateTime comingAt,
    required bool lateCreated,
    required int? lateId,
  }) = _ProcessComingByQrResponse;

  factory ProcessComingByQrResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessComingByQrResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension ProcessComingByQrResponseX on ProcessComingByQrResponse {
  OutingComingQrResultEntity toEntity() {
    return OutingComingQrResultEntity(
      action: action,
      outingId: outingId,
      status: status,
      comingAt: comingAt,
      lateCreated: lateCreated,
      lateId: lateId,
    );
  }
}
