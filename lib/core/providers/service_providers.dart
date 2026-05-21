import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/domain/services/permission_service.dart';
import 'package:goms/core/domain/services/settings_service.dart';
import 'package:goms/core/domain/services/notification_service.dart';
import 'package:goms/core/data/services_impl/permission_service_impl.dart';
import 'package:goms/core/data/services_impl/settings_service_impl.dart';
import 'package:goms/core/data/services_impl/notification_service_impl.dart';
import 'package:goms/features/notification/data/datasources/notification_api.dart';
import 'package:goms/core/network/dio_providers.dart';

/// Permission Service 제공자
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionServiceImpl();
});

/// Settings Service 제공자
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsServiceImpl();
});

/// Notification Service 제공자
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final notificationApi = NotificationApi(ref.watch(dioProvider));
  return NotificationServiceImpl(notificationApi);
});
