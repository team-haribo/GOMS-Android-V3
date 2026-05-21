abstract class NotificationRepository {
  Future<void> registerDeviceToken();

  Future<void> deleteDeviceToken();
}
