import 'package:goms/features/map/review/domain/enums/report_status.dart';

int parseReportInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

String parseReportString(Object? value) => value as String? ?? '';

String? parseNullableReportString(Object? value) {
  final stringValue = value as String?;
  if (stringValue == null || stringValue.isEmpty) {
    return null;
  }
  return stringValue;
}

DateTime? parseReportDateTime(Object? value) {
  final stringValue = value as String?;
  if (stringValue == null || stringValue.isEmpty) {
    return null;
  }
  return DateTime.tryParse(stringValue);
}

ReportStatus parseReportStatus(Object? value) {
  switch (value) {
    case 'APPROVED':
      return ReportStatus.approved;
    case 'REJECTED':
      return ReportStatus.rejected;
    case 'PENDING':
    default:
      return ReportStatus.pending;
  }
}
