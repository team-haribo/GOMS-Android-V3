import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goms/core/domain/services/notification_service.dart';
import 'package:goms/features/notification/data/datasources/notification_api.dart';

/// NotificationService의 구현체
/// 
/// Firebase Cloud Messaging과 Notification API를 사용하여 푸시 알림 관련 기능을 제공합니다.
class NotificationServiceImpl implements NotificationService {
  final NotificationApi _notificationApi;

  NotificationServiceImpl(this._notificationApi);

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).id;
    } else {
      return (await deviceInfo.iosInfo).identifierForVendor ?? '';
    }
  }

  @override
  Future<void> registerDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await _getDeviceId();

    if (fcmToken == null || fcmToken.trim().isEmpty) {
      return;
    }
    if (deviceId.trim().isEmpty) {
      return;
    }

    await _notificationApi.registerDeviceToken({
      'fcmToken': fcmToken,
      'platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
      'deviceId': deviceId,
    });
  }

  @override
  Future<void> deleteDeviceToken() async {
    final deviceId = await _getDeviceId();

    if (deviceId.trim().isEmpty) {
      return;
    }

    await _notificationApi.deleteDeviceToken(deviceId);
  }

  @override
  Future<String?> getDeviceToken() =>
      FirebaseMessaging.instance.getToken();

  @override
  Future<void> refreshDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
    await registerDeviceToken();
  }
}
