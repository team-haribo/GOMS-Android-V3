import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/qr/ui/screens/qr_issue_screen.dart';
import 'package:goms/features/qr/ui/screens/qr_scan_screen.dart';

List<RouteBase> buildQrRoutes() => [
      GoRoute(
        path: RoutePath.qr,
        name: 'qr',
        builder: (context, state) => const QrScanScreen(),
      ),
      GoRoute(
        path: RoutePath.qrIssue,
        name: 'qrIssue',
        builder: (context, state) => const QrIssueScreen(),
      ),
    ];
