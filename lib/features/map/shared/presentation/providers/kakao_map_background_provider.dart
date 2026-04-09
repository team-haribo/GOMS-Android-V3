import 'package:flutter_riverpod/legacy.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

final kakaoMapBackgroundErrorProvider =
    StateProvider.autoDispose.family<String?, String>((ref, mapId) => null);

final kakaoMapBackgroundControllerProvider =
    StateProvider.autoDispose.family<kakao.KakaoMapController?, String>(
      (ref, mapId) => null,
    );
