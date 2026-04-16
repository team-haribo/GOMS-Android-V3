import 'package:goms/features/qr/data/datasources/qr_remote_datasource.dart';
import 'package:goms/features/qr/data/response/issued_qr_response.dart';
import 'package:goms/features/qr/data/repositories/qr_repository.dart';
import 'package:goms/features/qr/ui/models/issued_qr_model.dart';

class QrRepositoryImpl implements QrRepository {
  const QrRepositoryImpl({
    required QrRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final QrRemoteDataSource _remoteDataSource;

  @override
  Future<IssuedQrModel> issueQr() async {
    final response = await _remoteDataSource.issueQr();
    return response.toModel();
  }
}
