import 'package:goms/features/outing/domain/entities/outing_coming_qr_result_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class ProcessComingByQrUseCase {
  const ProcessComingByQrUseCase(this._repository);

  final OutingRepository _repository;

  Future<OutingComingQrResultEntity> call({
    required String uuid,
    required int exp,
  }) {
    return _repository.processComingByQr(uuid: uuid, exp: exp);
  }
}
