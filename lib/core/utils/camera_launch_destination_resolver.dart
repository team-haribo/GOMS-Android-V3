import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/router/route_path.dart';

class CameraLaunchDestinationResolver {
  const CameraLaunchDestinationResolver._();

  static String? resolve({
    required bool enabled,
    required bool isCameraPermissionGranted,
    required RoleEnum role,
  }) {
    if (!enabled || !isCameraPermissionGranted) {
      return null;
    }

    return role == RoleEnum.admin ? RoutePath.qrIssue : RoutePath.qr;
  }
}
