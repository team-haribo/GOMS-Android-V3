import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';

abstract class OutingRepository {
  Future<MyOutingStatusEntity> getMyOutingStatus({
    required String accessToken,
  });
}
