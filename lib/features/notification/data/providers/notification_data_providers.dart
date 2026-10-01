import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/domain/services/notification_service.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/notification/data/datasources/notification_api.dart';
import 'package:goms/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:goms/features/notification/data/services/notification_service_impl.dart';

final notificationApiProvider = Provider<NotificationApi>(
  (ref) => NotificationApi(ref.watch(dioProvider)),
);

final notificationDataSourceProvider = Provider<NotificationRemoteDataSource>(
  (ref) => NotificationRemoteDataSource(
    ref.watch(notificationApiProvider),
  ),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationServiceImpl(ref.watch(notificationApiProvider)),
);