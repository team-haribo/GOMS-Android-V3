import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

enum OutingStatus {
  waiting,
  approved,
  rejected,
  admin;

  factory OutingStatus.fromServer(OutingStatusType value) {
    switch (value) {
      case OutingStatusType.outing:
      case OutingStatusType.coming:
        return OutingStatus.approved;
      case OutingStatusType.cannotOuting:
        return OutingStatus.rejected;
    }
  }

  String get statusText {
    switch (this) {
      case OutingStatus.waiting:
        return '외출 대기 중';
      case OutingStatus.approved:
        return '외출중';
      case OutingStatus.rejected:
        return '외출 금지';
      case OutingStatus.admin:
        return '학생회';
    }
  }

  Color get statusColor {
    switch (this) {
      case OutingStatus.waiting:
        return AppColors.sub1;
      case OutingStatus.approved:
        return AppColors.mainColor;
      case OutingStatus.rejected:
        return AppColors.negative;
      case OutingStatus.admin:
        return AppColors.admin;
    }
  }

  Color getStatusColor(bool isLight) {
    return (this == OutingStatus.waiting && !isLight)
        ? AppColors.sub1Dark
        : statusColor;
  }
}
