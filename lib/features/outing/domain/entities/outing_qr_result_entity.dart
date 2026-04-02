import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

class OutingQrResultEntity {
  const OutingQrResultEntity({
    required this.action,
    required this.outingId,
    required this.status,
    required this.outingAt,
  });

  final OutingAction action;
  final int outingId;
  final OutingStatusType status;
  final DateTime outingAt;
}
