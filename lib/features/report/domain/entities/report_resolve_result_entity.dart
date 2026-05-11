import 'package:flutter/foundation.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';

@immutable
class ReportResolveResultEntity {
  const ReportResolveResultEntity({
    required this.reportId,
    required this.reviewId,
    required this.reportStatus,
    required this.resolvedBy,
    this.resolvedAt,
  });

  final int reportId;
  final int reviewId;
  final ReportStatus reportStatus;
  final int resolvedBy;
  final DateTime? resolvedAt;
}
