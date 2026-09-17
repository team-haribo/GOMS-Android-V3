import 'package:go_router/go_router.dart';
import 'package:goms/features/qr/presentation/routes/qr_route_path.dart';
import 'package:goms/features/qr/presentation/screens/qr_issue_screen.dart';
import 'package:goms/features/qr/presentation/screens/qr_scan_screen.dart';

List<RouteBase> buildQrRoutes() => [
      GoRoute(
        path: QrRoutePath.qr,
        name: 'qr',
        builder: (context, state) => const QrScanScreen(),
      ),
      GoRoute(
        path: QrRoutePath.qrIssue,
        name: 'qrIssue',
        builder: (context, state) => const QrIssueScreen(),
      ),
      GoRoute(
        path: QrRoutePath.qrResult,
        name: 'qrResult',
        builder: (context, state) => buildQrScanResultRouteScreen(
          state.pathParameters['resultType'],
          context: context,
        ),
      ),
    ];
