import 'package:goms_design_system/goms_design_system.dart';
import 'package:flutter/material.dart';
import 'package:goms/features/outing/domain/enums/outing_status_type.dart';

enum OutingStatus {
  waiting,
  approved,
  rejected;

  factory OutingStatus.fromServer(OutingStatusType value) {
    switch (value) {
      case OutingStatusType.coming:
        return OutingStatus.waiting;

      case OutingStatusType.outing:
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
    }
  }

  Color getStatusColor(bool isLight) {
    return (this == OutingStatus.waiting && !isLight)
        ? AppColors.sub1Dark
        : statusColor;
  }
}