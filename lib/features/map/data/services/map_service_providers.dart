import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/services/kakao_local_service.dart';
import 'package:goms/features/map/data/services/kakao_mobility_service.dart';

final kakaoLocalServiceProvider = Provider<KakaoLocalService>((ref) {
  return KakaoLocalService();
});

final kakaoMobilityServiceProvider = Provider<KakaoMobilityService>((ref) {
  return KakaoMobilityService();
});
