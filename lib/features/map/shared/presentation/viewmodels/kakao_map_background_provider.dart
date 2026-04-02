import 'package:flutter_riverpod/legacy.dart';

final kakaoMapBackgroundErrorProvider =
    StateProvider.autoDispose.family<String?, String>((ref, mapId) => null);
