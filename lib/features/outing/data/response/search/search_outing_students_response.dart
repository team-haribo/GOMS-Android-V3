import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:goms/features/outing/data/response/outing_student_response.dart';
import 'package:goms/features/outing/ui/models/outing_student_model.dart';

part 'search_outing_students_response.freezed.dart';
part 'search_outing_students_response.g.dart';

@freezed
abstract class SearchOutingStudentsResponse
    with _$SearchOutingStudentsResponse {
  const factory SearchOutingStudentsResponse({
    required List<OutingStudentResponse> students,
  }) = _SearchOutingStudentsResponse;

  factory SearchOutingStudentsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchOutingStudentsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson();
}

extension SearchOutingStudentsResponseX on SearchOutingStudentsResponse {
  List<OutingStudentModel> toModel() {
    return students.map((student) => student.toModel()).toList();
  }
}
