import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/home/shared/presentation/providers/time_provider.dart';

class TimeDisplay extends ConsumerWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
    final ampm = DateFormat('a', 'en_US').format(now);
    final time = DateFormat('h : mm : ss').format(now);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$ampm ',
            style:
                AppTextStyles.dateTimeAmPm.copyWith(color: context.sub2Color),
          ),
          TextSpan(
            text: time,
            style: AppTextStyles.dateTime.copyWith(color: context.sub2Color),
          ),
        ],
      ),
    );
  }
}
