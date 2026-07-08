import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTimeProvider = StreamProvider.autoDispose<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});
