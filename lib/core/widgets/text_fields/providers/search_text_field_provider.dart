import 'package:flutter_riverpod/legacy.dart';

final searchTextHasValueProvider =
    StateProvider.autoDispose.family<bool, Object>((ref, key) => false);
