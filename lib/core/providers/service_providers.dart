import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/domain/services/permission_service.dart';
import 'package:goms/core/data/services_impl/permission_service_impl.dart';

/// Permission Service 제공자
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionServiceImpl();
});
