import 'package:goms/features/outing/data/datasources/outing_remote_datasource.dart';
import 'package:goms/features/outing/data/response/status/my_outing_status_response.dart';
import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/repositories/outing_repository.dart';

class OutingRepositoryImpl implements OutingRepository {
  const OutingRepositoryImpl({
    required OutingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final OutingRemoteDataSource _remoteDataSource;

  @override
  Future<MyOutingStatusEntity> getMyOutingStatus({
    required String accessToken,
  }) async {
    final response = await _remoteDataSource.getMyOutingStatus(
      _toBearerToken(accessToken),
    );
    return response.toEntity();
  }

  String _toBearerToken(String token) {
    final trimmedToken = token.trim();
    if (trimmedToken.startsWith('Bearer ')) {
      return trimmedToken;
    }
    return 'Bearer $trimmedToken';
  }
}
