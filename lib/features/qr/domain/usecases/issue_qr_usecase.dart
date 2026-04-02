import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/domain/repositories/qr_repository.dart';

class IssueQrUseCase {
  const IssueQrUseCase(this._repository);

  final QrRepository _repository;

  Future<IssuedQrEntity> call() {
    return _repository.issueQr();
  }
}
