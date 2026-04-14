import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goms/core/utils/token_storage.dart';

class NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSource(this._dio);

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).id;
    } else {
      return (await deviceInfo.iosInfo).identifierForVendor ?? '';
    }
  }

  Future<void> registerDeviceToken() async {
    final accessToken = await TokenStorage.getAccessToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final deviceId = await _getDeviceId();

    if (accessToken == null || fcmToken == null) return;

    try {
      await _dio.post(
        'https://goms.io.kr:23241/api/v3/notification/token',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          'fcmToken': fcmToken,
          'platform': 'ANDROID',
          'deviceId': deviceId,
        },
      );

      print('등록 성공');
    } on DioException catch (e) {
      print('등록 실패: ${e.response?.statusCode}');
      rethrow;
    }
  }

  Future<void> deleteDeviceToken() async {
    final accessToken = await TokenStorage.getAccessToken();
    final deviceId = await _getDeviceId();

    if (accessToken == null) return;

    try {
      await _dio.delete(
        'https://goms.io.kr:23241/api/v3/notification/token/$deviceId',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      print('삭제 성공');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      print('삭제 실패: ${e.response?.statusCode}');
      rethrow;

    }
  }
}