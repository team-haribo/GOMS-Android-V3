import 'package:flutter_test/flutter_test.dart';
import 'package:goms/features/map/review/domain/enums/report_status.dart';
import 'package:goms/features/report/ui/screens/admin_report_list_screen.dart';

void main() {
  group('matchesReportStatusFilter', () {
    test('필터가 없으면 모든 상태를 포함한다', () {
      expect(
        matchesReportStatusFilter(
          filter: null,
          status: ReportStatus.pending,
        ),
        isTrue,
      );
      expect(
        matchesReportStatusFilter(
          filter: null,
          status: ReportStatus.approved,
        ),
        isTrue,
      );
      expect(
        matchesReportStatusFilter(
          filter: null,
          status: ReportStatus.rejected,
        ),
        isTrue,
      );
    });

    test('처리전 필터는 pending만 포함한다', () {
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.pending,
          status: ReportStatus.pending,
        ),
        isTrue,
      );
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.pending,
          status: ReportStatus.approved,
        ),
        isFalse,
      );
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.pending,
          status: ReportStatus.rejected,
        ),
        isFalse,
      );
    });

    test('처리완료 필터는 approved와 rejected를 모두 포함한다', () {
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.approved,
          status: ReportStatus.approved,
        ),
        isTrue,
      );
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.approved,
          status: ReportStatus.rejected,
        ),
        isTrue,
      );
      expect(
        matchesReportStatusFilter(
          filter: ReportStatus.approved,
          status: ReportStatus.pending,
        ),
        isFalse,
      );
    });
  });
}
