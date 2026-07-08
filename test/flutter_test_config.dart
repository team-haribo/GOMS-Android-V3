import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 모든 위젯 테스트 실행 전 ScreenUtil을 디자인 크기(360x800)로 초기화한다.
///
/// 실기기 크기가 아닌 디자인 크기로 고정하므로 스케일 비율이 1이 되어
/// AppGap 등 screenutil 기반 간격이 기존 디자인 px 값 그대로 동작한다.
/// (실 앱은 main.dart의 ScreenUtilInit가 담당한다.)
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  ScreenUtil.configure(
    data: const MediaQueryData(size: Size(360, 800)),
    designSize: const Size(360, 800),
    splitScreenMode: false,
    minTextAdapt: false,
  );
  await testMain();
}
