import 'package:goms/features/qr/data/datasources/qr_remote_datasource.dart';
import 'package:goms/features/qr/data/response/issued_qr_response.dart';
import 'package:goms/features/qr/domain/entities/issued_qr_entity.dart';
import 'package:goms/features/qr/domain/repositories/qr_repository.dart';

class QrRepositoryImpl implements QrRepository {
  const QrRepositoryImpl({
    required QrRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final QrRemoteDataSource _remoteDataSource;

  @override
  Future<IssuedQrEntity> issueQr() async {
    final response = await _remoteDataSource.issueQr();
    return response.toEntity();
  }
}
