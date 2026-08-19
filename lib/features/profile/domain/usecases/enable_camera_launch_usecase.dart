import 'package:permission_handler/permission_handler.dart';
import 'package:goms/core/domain/services/permission_service.dart';
import 'package:goms/core/utils/settings_storage.dart';

/// 카메라 자동 실행 활성화 UseCase
///
/// 카메라 권한을 요청하고, 설정값을 저장합니다.
class EnableCameraLaunchUseCase {
  final PermissionService _permissionService;

  EnableCameraLaunchUseCase({
    required PermissionService permissionService,
  }) : _permissionService = permissionService;

  /// 카메라 자동 실행 활성화
  ///
  /// 카메라 권한을 요청하고, 권한이 있으면 설정값을 저장합니다.
  ///
  /// 반환값: true (성공) 또는 false (실패)
  Future<bool> call() async {
    try {
      final status = await _permissionService.requestCameraPermission();

      // PermissionStatus가 granted가 아니면 실패
      if (status != PermissionStatus.granted) {
        return false;
      }

      await SettingsStorage.setCameraLaunch(true);
      return true;
    } catch (_) {
      return false;
    }
  }
}
