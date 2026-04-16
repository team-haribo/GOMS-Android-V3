import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_builders.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/report/ui/screens/admin_report_detail_screen.dart';
import 'package:goms/features/report/ui/screens/admin_report_list_screen.dart';

List<RouteBase> buildReportRoutes() => [
      GoRoute(
        path: RoutePath.studentCouncilReports,
        name: 'studentCouncilReports',
        builder: (context, state) => const AdminReportListScreen(),
      ),
      GoRoute(
        path: RoutePath.studentCouncilReportDetail,
        name: 'studentCouncilReportDetail',
        builder: (context, state) {
          final reportId = extraAsOrNull<int>(state.extra);
          if (reportId == null) {
            return buildInvalidRouteAccessScreen();
          }
          return AdminReportDetailScreen(reportId: reportId);
        },
      ),
    ];
