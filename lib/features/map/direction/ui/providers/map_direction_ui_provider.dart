import 'package:flutter_riverpod/legacy.dart';

final routeSheetVisibilityProvider =
    StateProvider.autoDispose.family<bool, String>((ref, routeId) => false);
