import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';

abstract class QrRepository {
  Future<IssuedQrEntity> issueQr();
}
