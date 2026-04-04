import 'package:goms/features/map/review/domain/enums/report_status.dart';

class ReportResolveRequest {
  const ReportResolveRequest({
    required this.reportStatus,
  });

  final ReportStatus reportStatus;

  Map<String, dynamic> toJson() {
    return {
      'reportStatus': switch (reportStatus) {
        ReportStatus.pending => 'PENDING',
        ReportStatus.approved => 'APPROVED',
        ReportStatus.rejected => 'REJECTED',
      },
    };
  }
}
