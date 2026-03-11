import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:goms/core/utils/settings_storage.dart';

class SettingsState {
  final bool showClock;
  final bool outingPushAlarm;
  final bool cameraLaunch;

  const SettingsState({
    required this.showClock,
    required this.outingPushAlarm,
    required this.cameraLaunch,
  });

  SettingsState copyWith({
    bool? showClock,
    bool? outingPushAlarm,
    bool? cameraLaunch,
  }) {
    return SettingsState(
      showClock: showClock ?? this.showClock,
      outingPushAlarm: outingPushAlarm ?? this.outingPushAlarm,
      cameraLaunch: cameraLaunch ?? this.cameraLaunch,
    );
  }
}

/// 마이페이지 설정 3종(시계, 외출제 알림, 카메라 바로 켜기)을 관리하는 Provider
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    return SettingsState(
      showClock: await SettingsStorage.getShowClock(),
      outingPushAlarm: await SettingsStorage.getOutingPushAlarm(),
      cameraLaunch: await SettingsStorage.getCameraLaunch(),
    );
  }

  Future<void> setShowClock(bool value) async {
    await SettingsStorage.setShowClock(value);
    state = AsyncData(state.requireValue.copyWith(showClock: value));
  }

  /// 외출제 푸시 알림 설정 변경
  /// 활성화 시 알림 권한을 요청하며, 거부된 경우 false 반환
  Future<bool> setOutingPushAlarm(bool value) async {
    if (value) {
      final result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final granted =
          result.authorizationStatus == AuthorizationStatus.authorized ||
              result.authorizationStatus == AuthorizationStatus.provisional;
      if (!granted) return false;
    }
    await SettingsStorage.setOutingPushAlarm(value);
    state = AsyncData(state.requireValue.copyWith(outingPushAlarm: value));
    return true;
  }

  /// 카메라 바로 켜기 설정 변경
  /// 활성화 시 카메라 권한을 요청하며, 영구 거부 시 설정 앱을 열고 false 반환
  Future<bool> setCameraLaunch(bool value) async {
    if (value) {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        status = await Permission.camera.request();
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      if (!status.isGranted) return false;
    }
    await SettingsStorage.setCameraLaunch(value);
    state = AsyncData(state.requireValue.copyWith(cameraLaunch: value));
    return true;
  }
}
