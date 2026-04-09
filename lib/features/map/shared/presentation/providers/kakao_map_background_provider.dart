import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart' as kakao;

final kakaoMapBackgroundErrorProvider =
    NotifierProvider.autoDispose.family<
      _KakaoMapBackgroundErrorNotifier,
      String?,
      String
    >(_KakaoMapBackgroundErrorNotifier.new);

final kakaoMapBackgroundControllerProvider =
    NotifierProvider.autoDispose.family<
      _KakaoMapBackgroundControllerNotifier,
      kakao.KakaoMapController?,
      String
    >(_KakaoMapBackgroundControllerNotifier.new);

class _KakaoMapBackgroundErrorNotifier extends Notifier<String?> {
  _KakaoMapBackgroundErrorNotifier(this.mapId);

  final String mapId;

  @override
  String? build() => null;

  void setMessage(String? value) => state = value;
}

class _KakaoMapBackgroundControllerNotifier
    extends Notifier<kakao.KakaoMapController?> {
  _KakaoMapBackgroundControllerNotifier(this.mapId);

  final String mapId;

  @override
  kakao.KakaoMapController? build() => null;

  void setController(kakao.KakaoMapController? value) => state = value;
}
