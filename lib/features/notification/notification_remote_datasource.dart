import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_api.dart';

class NotificationRemoteDataSource {
  final NotificationApi _api;

  NotificationRemoteDataSource(this._api);

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).id;
    } else {
      return (await deviceInfo.iosInfo).identifierForVendor ?? '';
    }
  }

  Future<void> registerDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await _getDeviceId();

    if (fcmToken == null) return;

    await _api.registerDeviceToken({
      'fcmToken': fcmToken,
      'platform': 'ANDROID',
      'deviceId': deviceId,
    });
  }

  Future<void> deleteDeviceToken() async {
    final deviceId = await _getDeviceId();

    await _api.deleteDeviceToken(deviceId);
  }
}