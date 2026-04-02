import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class ProcessOutingByQrUseCase {
  const ProcessOutingByQrUseCase(this._repository);

  final OutingRepository _repository;

  Future<OutingQrResultEntity> call({
    required String uuid,
    required int exp,
  }) {
    return _repository.processOutingByQr(uuid: uuid, exp: exp);
  }
}
