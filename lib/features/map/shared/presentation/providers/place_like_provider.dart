import 'package:flutter_riverpod/legacy.dart';

final placeLikeProvider =
    StateProvider.autoDispose.family<bool, String>((ref, placeId) => false);
