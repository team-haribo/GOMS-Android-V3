import 'package:goms/features/outing/domain/entities/my_outing_status_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_coming_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_qr_result_entity.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';

abstract class OutingRepository {
  Future<MyOutingStatusEntity> getMyOutingStatus();
  Future<List<OutingStudentEntity>> getCurrentOutingStudents();
  Future<OutingQrResultEntity> processOutingByQr({
    required String uuid,
    required int exp,
  });
  Future<OutingComingQrResultEntity> processComingByQr({
    required String uuid,
    required int exp,
  });
  Future<List<OutingStudentEntity>> searchOutingStudents({
    required String name,
  });
  Future<OutingQrResultEntity> forceOutStudent({
    required int memberId,
  });
  Future<OutingComingQrResultEntity> forceInStudent({
    required int memberId,
  });
}
