import 'dart:io';
import 'package:dio/dio.dart';
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

    if (fcmToken == null || fcmToken.trim().isEmpty) {
      return;
    }
    if (deviceId.trim().isEmpty) {
      return;
    }

    await _api.registerDeviceToken({
      'fcmToken': fcmToken,
      'platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
      'deviceId': deviceId,
    });
  }

  Future<void> deleteDeviceToken() async {
    final deviceId = await _getDeviceId();

    if (deviceId.trim().isEmpty) {
      return;
    }

    try {
      await _api.deleteDeviceToken(deviceId);
    } on DioException catch (error) {
      // 이미 서버에 토큰이 없는 상태(멱등 삭제)는 성공으로 취급한다.
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 404) {
        return;
      }
      rethrow;
    }
  }
}
