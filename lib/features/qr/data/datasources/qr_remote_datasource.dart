import 'package:dio/dio.dart';
import 'package:goms/features/qr/data/response/issued_qr_response.dart';
import 'package:retrofit/retrofit.dart';

part 'qr_remote_datasource.g.dart';

@RestApi()
abstract class QrRemoteDataSource {
  factory QrRemoteDataSource(Dio dio, {String? baseUrl}) = _QrRemoteDataSource;

  @POST('/api/v3/student-council/qr')
  Future<IssuedQrResponse> issueQr();
}
