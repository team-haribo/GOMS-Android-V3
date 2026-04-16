import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/app/router/route_path.dart';

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

    if (role == RoleEnum.admin) {
      return null;
    }

    return RoutePath.qr;
  }
}
