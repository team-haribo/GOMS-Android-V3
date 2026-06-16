import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/app/router/route_path.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/qr/presentation/models/qr_scan_state.dart';
import 'package:goms/features/qr/presentation/providers/qr_scan_provider.dart';
import 'package:goms/features/qr/presentation/screens/cannot_go_out_screen.dart';
import 'package:goms/features/qr/presentation/screens/late_screen.dart';
import 'package:goms/features/qr/presentation/screens/outing_failed_screen.dart';
import 'package:goms/features/qr/presentation/screens/outing_start_screen.dart';
import 'package:goms/features/qr/presentation/screens/return_success_screen.dart';

class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  late final ProviderSubscription<QrScanState> _qrScanSubscription;

  @override
  void initState() {
    super.initState();
    _qrScanSubscription = ref.listenManual<QrScanState>(qrScanProvider, (
        previous,
        next,
        ) async {
      if (!mounted) return;

      if (next.status == QrScanStatus.failure && next.errorMessage != null) {
        await context.push(RoutePath.qrResultLocation('failure'));
        if (mounted) context.pop();
        return;
      }

      if (next.status == QrScanStatus.success && next.resultType != null) {
        await context.push(RoutePath.qrResultLocation(next.resultType!.name));
        if (mounted) context.pop();
      }
    });
  }

  @override
  void dispose() {
    _qrScanSubscription.close();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (ref.read(qrScanProcessingProvider)) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    _controller.stop();
    await ref.read(qrScanProvider.notifier).processScan(barcode.rawValue!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ==================== 카메라 전체 화면 ====================
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // ==================== 어두운 오버레이 + 스캔 박스 ====================
          _ScanOverlay(),

          // ==================== 상단 앱바 ====================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  AppIcons.gomsLogo(
                    width: 32,
                    height: 32,
                    color: AppColors.mainTextDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GOMS',
                    style: AppTextStyles.title3.withColor(Colors.white),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child:
                    const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 스캔 박스 오버레이 (사각형 안쪽만 비움)
class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const boxSize = 220.0;
    final boxLeft = (size.width - boxSize) / 2;
    final boxTop = (size.height - boxSize) / 2 - 40;
    final scanRect = Rect.fromLTWH(boxLeft, boxTop, boxSize, boxSize);

    return CustomPaint(
      size: size,
      painter: _OverlayPainter(scanRect: scanRect),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  const _OverlayPainter({required this.scanRect});

  final Rect scanRect;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withAlpha(153);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    // 전체에서 스캔 영역을 뺀 어두운 마스크
    final path = Path()
      ..addRect(fullRect)
      ..addRect(scanRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    // 네 모서리 흰 브라켓
    final bracketPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 56.0;
    final l = scanRect.left;
    final t = scanRect.top;
    final r = scanRect.right;
    final b = scanRect.bottom;

    // 좌상단
    canvas.drawLine(Offset(l, t + len), Offset(l, t), bracketPaint);
    canvas.drawLine(Offset(l, t), Offset(l + len, t), bracketPaint);
    // 우상단
    canvas.drawLine(Offset(r - len, t), Offset(r, t), bracketPaint);
    canvas.drawLine(Offset(r, t), Offset(r, t + len), bracketPaint);
    // 우하단
    canvas.drawLine(Offset(r, b - len), Offset(r, b), bracketPaint);
    canvas.drawLine(Offset(r, b), Offset(r - len, b), bracketPaint);
    // 좌하단
    canvas.drawLine(Offset(l + len, b), Offset(l, b), bracketPaint);
    canvas.drawLine(Offset(l, b), Offset(l, b - len), bracketPaint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) =>
      oldDelegate.scanRect != scanRect;
}

Widget buildQrScanResultScreen(
    QrScanResultType resultType, {
      required BuildContext context,
    }) {
  void goHome() => context.pop();

  switch (resultType) {
    case QrScanResultType.outingStarted:
      return OutingStartScreen(onConfirm: goHome);
    case QrScanResultType.returnSuccess:
      return ReturnSuccessScreen(onConfirm: goHome);
    case QrScanResultType.lateReturn:
      return LateScreen(onConfirm: goHome);
    case QrScanResultType.cannotGoOut:
      return CannotGoOutScreen(onGoHome: goHome);
  }
}

Widget buildQrScanResultRouteScreen(
    String? resultTypeName, {
      required BuildContext context,
    }) {
  if (resultTypeName == 'failure') {
    return OutingFailedScreen(
      onRetryWithCamera: () => context.go(RoutePath.qr),
    );
  }

  final resultType = QrScanResultType.values
      .where((type) => type.name == resultTypeName)
      .firstOrNull;

  if (resultType == null) {
    return OutingFailedScreen(
      onRetryWithCamera: () => context.go(RoutePath.qr),
    );
  }

  return buildQrScanResultScreen(resultType, context: context);
}