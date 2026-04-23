import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms/features/notification/notification_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<bool> setOutingPushAlarm(bool value) async {
    final dataSource = ref.read(notificationDataSourceProvider);

    if (value) {
      var status = await Permission.notification.status;
      if (status.isDenied) {
        status = await Permission.notification.request();
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      if (!status.isGranted) return false;

      await dataSource.registerDeviceToken();
    } else {
      await dataSource.deleteDeviceToken();
    }

    await SettingsStorage.setOutingPushAlarm(value);
    state = AsyncData(state.requireValue.copyWith(outingPushAlarm: value));
    return true;
  }

  Future<bool> setCameraLaunch(bool value) async {
    final role = ref.read(roleProvider);

    if (value && role != RoleEnum.admin) {
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
