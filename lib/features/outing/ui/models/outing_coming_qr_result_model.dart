import 'package:flutter/foundation.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

@immutable
class OutingComingQrResultModel {
  const OutingComingQrResultModel({
    required this.action,
    required this.outingId,
    required this.status,
    required this.comingAt,
    required this.lateCreated,
    required this.lateId,
  });

  final OutingAction action;
  final int outingId;
  final OutingStatusType status;
  final DateTime comingAt;
  final bool lateCreated;
  final int lateId;
}
