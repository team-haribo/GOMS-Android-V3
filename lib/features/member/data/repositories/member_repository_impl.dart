import 'package:goms/features/member/data/datasources/member_remote_datasource.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/domain/repositories/member_repository.dart';

class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl(this._remoteDataSource);

  final MemberRemoteDataSource _remoteDataSource;

  @override
  Future<List<MemberEntity>> getMembers() async {
    final members = await _remoteDataSource.getMembers();
    return members.map((member) => member.toEntity()).toList();
  }
}
