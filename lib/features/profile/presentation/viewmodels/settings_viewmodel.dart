import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/utils/settings_storage.dart';
import 'package:goms/features/profile/data/providers/profile_data_providers.dart';

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
    if (value) {
      final success =
          await ref.read(enablePushNotificationUseCaseProvider).call();
      if (success) {
        state = AsyncData(state.requireValue.copyWith(outingPushAlarm: true));
      }
      return success;
    } else {
      final success =
          await ref.read(disablePushNotificationUseCaseProvider).call();
      if (success) {
        state = AsyncData(state.requireValue.copyWith(outingPushAlarm: false));
      }
      return success;
    }
  }

  Future<bool> setCameraLaunch(bool value) async {
    final role = ref.read(roleProvider);

    if (value && role != RoleEnum.admin) {
      final success =
          await ref.read(enableCameraLaunchUseCaseProvider).call();
      if (success) {
        state = AsyncData(state.requireValue.copyWith(cameraLaunch: true));
      }
      return success;
    } else {
      await SettingsStorage.setCameraLaunch(value);
      state = AsyncData(state.requireValue.copyWith(cameraLaunch: value));
      return true;
    }
  }
}