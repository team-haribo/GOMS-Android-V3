import 'package:flutter_riverpod/legacy.dart';

final qrScanProcessingProvider =
    StateProvider.autoDispose<bool>((ref) => false);
