import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/notification/presentation/notification_api.dart';
import 'package:goms/features/notification/presentation/notification_remote_datasource.dart';

final notificationApiProvider = Provider<NotificationApi>(
      (ref) => NotificationApi(ref.read(dioProvider)),
);

final notificationDataSourceProvider =
Provider<NotificationRemoteDataSource>(
      (ref) => NotificationRemoteDataSource(
    ref.read(notificationApiProvider),
  ),
);