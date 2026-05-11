import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:goms/features/qr/presentation/screens/qr_issue_screen.dart';
import 'package:goms/features/qr/presentation/screens/qr_scan_screen.dart';

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
      GoRoute(
        path: RoutePath.qrResult,
        name: 'qrResult',
        builder: (context, state) => buildQrScanResultRouteScreen(
          state.pathParameters['resultType'],
          context: context,
        ),
      ),
    ];
