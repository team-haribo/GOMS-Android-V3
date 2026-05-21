import 'package:goms/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:goms/features/profile/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<void> registerDeviceToken() {
    return _remoteDataSource.registerDeviceToken();
  }

  @override
  Future<void> deleteDeviceToken() {
    return _remoteDataSource.deleteDeviceToken();
  }
}
