import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/providers/service_providers.dart';
import 'package:goms/features/notification/data/providers/notification_data_providers.dart';
import 'package:goms/features/profile/data/repositories/notification_repository_impl.dart';
import 'package:goms/features/profile/domain/repositories/notification_repository.dart';
import 'package:goms/features/profile/domain/usecases/enable_push_notification_usecase.dart';
import 'package:goms/features/profile/domain/usecases/disable_push_notification_usecase.dart';
import 'package:goms/features/profile/domain/usecases/enable_camera_launch_usecase.dart';

/// Profile 관련 Data Providers

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.watch(notificationDataSourceProvider),
  );
});

final enablePushNotificationUseCaseProvider =
    Provider<EnablePushNotificationUseCase>((ref) {
  return EnablePushNotificationUseCase(
    permissionService: ref.watch(permissionServiceProvider),
    settingsService: ref.watch(settingsServiceProvider),
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
});

final disablePushNotificationUseCaseProvider =
    Provider<DisablePushNotificationUseCase>((ref) {
  return DisablePushNotificationUseCase(
    settingsService: ref.watch(settingsServiceProvider),
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
});

final enableCameraLaunchUseCaseProvider =
    Provider<EnableCameraLaunchUseCase>((ref) {
  return EnableCameraLaunchUseCase(
    permissionService: ref.watch(permissionServiceProvider),
    settingsService: ref.watch(settingsServiceProvider),
  );
});
