import 'package:goms/features/outing/presentation/models/my_outing_status_model.dart';
import 'package:goms/features/outing/presentation/models/outing_coming_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_qr_result_model.dart';
import 'package:goms/features/outing/presentation/models/outing_student_model.dart';

abstract class OutingRepository {
  Future<MyOutingStatusModel> getMyOutingStatus();

  Future<List<OutingStudentModel>> getCurrentOutingStudents();

  Future<OutingQrResultModel> processOutingByQr({
    required String uuid,
    required int exp,
  });

  Future<OutingComingQrResultModel> processComingByQr({
    required String uuid,
    required int exp,
  });

  Future<List<OutingStudentModel>> searchOutingStudents({
    required String name,
  });

  Future<OutingQrResultModel> forceOutStudent({
    required int memberId,
  });

  Future<OutingComingQrResultModel> forceInStudent({
    required int memberId,
  });
}
