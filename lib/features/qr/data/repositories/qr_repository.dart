import 'package:goms/features/qr/presentation/models/issued_qr_model.dart';

abstract class QrRepository {
  Future<IssuedQrModel> issueQr();
}
