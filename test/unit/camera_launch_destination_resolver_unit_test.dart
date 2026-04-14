import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/utils/camera_launch_destination_resolver.dart';

void main() {
  group('CameraLaunchDestinationResolver', () {
    test('설정이 꺼져 있으면 자동 실행하지 않는다', () {
      final destination = CameraLaunchDestinationResolver.resolve(
        enabled: false,
        isCameraPermissionGranted: true,
        role: RoleEnum.user,
      );

      expect(destination, isNull);
    });

    test('카메라 권한이 없으면 자동 실행하지 않는다', () {
      final destination = CameraLaunchDestinationResolver.resolve(
        enabled: true,
        isCameraPermissionGranted: false,
        role: RoleEnum.admin,
      );

      expect(destination, isNull);
    });

    test('학생 계정은 QR 스캔 화면으로 이동한다', () {
      final destination = CameraLaunchDestinationResolver.resolve(
        enabled: true,
        isCameraPermissionGranted: true,
        role: RoleEnum.user,
      );

      expect(destination, RoutePath.qr);
    });

    test('학생회 계정은 QR 발급 화면을 자동으로 열지 않는다', () {
      final destination = CameraLaunchDestinationResolver.resolve(
        enabled: true,
        isCameraPermissionGranted: true,
        role: RoleEnum.admin,
      );

      expect(destination, isNull);
    });
  });
}
