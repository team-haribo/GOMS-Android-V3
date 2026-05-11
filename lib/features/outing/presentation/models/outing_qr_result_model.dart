import 'package:flutter/foundation.dart';
import 'package:goms/features/outing/domain/enums/outing_action.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

@immutable
class OutingQrResultModel {
  const OutingQrResultModel({
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
