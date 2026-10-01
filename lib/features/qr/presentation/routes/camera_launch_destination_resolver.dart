import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/features/qr/presentation/routes/qr_route_path.dart';

class CameraLaunchDestinationResolver {
  const CameraLaunchDestinationResolver._();

  static String? resolve({
    required bool enabled,
    required bool isCameraPermissionGranted,
    required RoleEnum role,
  }) {
    if (!enabled) {
      return null;
    }

    if (role == RoleEnum.admin) {
      return QrRoutePath.qrIssue;
    }

    if (!isCameraPermissionGranted) {
      return null;
    }

    return QrRoutePath.qr;
  }
}
