import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class GetMyOutingStatusUseCase {
  const GetMyOutingStatusUseCase(this._repository);

  final OutingRepository _repository;

  Future<MyOutingStatusEntity> call({
    required String accessToken,
  }) {
    return _repository.getMyOutingStatus(accessToken: accessToken);
  }
}
