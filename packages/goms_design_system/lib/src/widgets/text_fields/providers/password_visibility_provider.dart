import 'package:flutter_riverpod/legacy.dart';

final passwordVisibilityProvider =
    StateProvider.autoDispose.family<bool, Object>((ref, key) => true);
