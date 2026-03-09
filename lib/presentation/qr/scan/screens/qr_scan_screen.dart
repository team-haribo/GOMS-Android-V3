import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isProcessing = true);
    _controller.stop();

    // TODO: QR 값으로 API 호출 후 결과 화면으로 이동
    // 현재는 스캔 값 출력 후 pop
    final value = barcode.rawValue!;
    debugPrint('QR scanned: $value');

    // 결과 처리 후 이전 화면으로
    if (mounted) context.pop();
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
                      width: 32, height: 32, color: AppColors.mainTextDark),
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

    return Stack(
      children: [
        // 네 방향 어두운 마스크
        // 위
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: boxTop,
          child: _darkMask(),
        ),
        // 아래
        Positioned(
          top: boxTop + boxSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: _darkMask(),
        ),
        // 왼쪽
        Positioned(
          top: boxTop,
          left: 0,
          width: boxLeft,
          height: boxSize,
          child: _darkMask(),
        ),
        // 오른쪽
        Positioned(
          top: boxTop,
          right: 0,
          width: boxLeft,
          height: boxSize,
          child: _darkMask(),
        ),

        // ==================== 흰색 모서리 브라켓 ====================
        Positioned(
          left: boxLeft,
          top: boxTop,
          width: boxSize,
          height: boxSize,
          child: const _CornerBrackets(),
        ),
      ],
    );
  }

  Widget _darkMask() =>
      Container(color: Colors.black.withAlpha(153)); // 60% opacity
}

/// 네 모서리 흰 브라켓
class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BracketPainter());
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 56.0; // 브라켓 길이
    final w = size.width;
    final h = size.height;

    // 좌상단
    canvas.drawLine(const Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    // 우상단
    canvas.drawLine(Offset(w - len, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);
    // 우하단
    canvas.drawLine(Offset(w, h - len), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w - len, h), paint);
    // 좌하단
    canvas.drawLine(Offset(len, h), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
