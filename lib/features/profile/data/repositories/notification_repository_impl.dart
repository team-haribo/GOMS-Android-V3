import 'package:goms/features/notification/presentation/notification_remote_datasource.dart';
import 'package:goms/features/profile/domain/repositories/notification_repository.dart';

/// NotificationRepository의 구현체
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<void> registerDeviceToken() =>
      _dataSource.registerDeviceToken();

  @override
  Future<void> deleteDeviceToken() =>
      _dataSource.deleteDeviceToken();
}
