import 'package:flutter/widgets.dart';

/// 루트 네비게이터 키.
///
/// 라우터 정의(`app_router.dart`)와, 라우터에 의존하지 않는 곳(예: 세션 만료
/// 처리)에서 모두 사용하기 위해 별도 파일로 분리한다. 이렇게 하면
/// `session_viewmodel` 등이 `app_router`를 직접 import 하면서 생기는 순환 의존을
/// 피할 수 있다.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
