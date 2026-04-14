import 'package:goms/features/qr/ui/models/issued_qr_model.dart';

abstract class QrRepository {
  Future<IssuedQrModel> issueQr();
}
