import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/providers/service_providers.dart';
import 'package:goms/features/notification/presentation/notification_provider.dart';
import 'package:goms/features/profile/data/repositories/notification_repository_impl.dart';
import 'package:goms/features/profile/domain/repositories/notification_repository.dart';
import 'package:goms/features/profile/domain/usecases/enable_push_notification_usecase.dart';
import 'package:goms/features/profile/domain/usecases/disable_push_notification_usecase.dart';
import 'package:goms/features/profile/domain/usecases/enable_camera_launch_usecase.dart';

/// Profile 관련 Data Providers

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.read(notificationDataSourceProvider),
  );
});

final enablePushNotificationUseCaseProvider =
    Provider<EnablePushNotificationUseCase>((ref) {
  return EnablePushNotificationUseCase(
    permissionService: ref.read(permissionServiceProvider),
    settingsService: ref.read(settingsServiceProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
});

final disablePushNotificationUseCaseProvider =
    Provider<DisablePushNotificationUseCase>((ref) {
  return DisablePushNotificationUseCase(
    settingsService: ref.read(settingsServiceProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
});

final enableCameraLaunchUseCaseProvider =
    Provider<EnableCameraLaunchUseCase>((ref) {
  return EnableCameraLaunchUseCase(
    permissionService: ref.read(permissionServiceProvider),
    settingsService: ref.read(settingsServiceProvider),
  );
});
