import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String? baseUrl}) = _NotificationApi;

  @POST('/api/v3/notification/token')
  Future<void> registerDeviceToken(
      @Body() Map<String, dynamic> body,
      );

  @DELETE('/api/v3/notification/token/{deviceId}')
  Future<void> deleteDeviceToken(
      @Path('deviceId') String deviceId,
      );
}