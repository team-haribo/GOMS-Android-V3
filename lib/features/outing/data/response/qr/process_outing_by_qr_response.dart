import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';
import 'package:goms/features/outing/ui/models/outing_qr_result_model.dart';

part 'process_outing_by_qr_response.freezed.dart';
part 'process_outing_by_qr_response.g.dart';

@freezed
abstract class ProcessOutingByQrResponse with _$ProcessOutingByQrResponse {
  const factory ProcessOutingByQrResponse({
    required OutingAction action,
    required int outingId,
    required OutingStatusType status,
    required DateTime outingAt,
  }) = _ProcessOutingByQrResponse;

  factory ProcessOutingByQrResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessOutingByQrResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension ProcessOutingByQrResponseX on ProcessOutingByQrResponse {
  OutingQrResultModel toModel() {
    return OutingQrResultModel(
      action: action,
      outingId: outingId,
      status: status,
      outingAt: outingAt,
    );
  }
}
