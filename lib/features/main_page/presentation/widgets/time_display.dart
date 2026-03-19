import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  late String _ampm;
  late String _time;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _updateTime();
        });
      }
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    _ampm = DateFormat('a', 'en_US').format(now);
    _time = DateFormat('h : mm : ss').format(now);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$_ampm ',
            style: AppTextStyles.dateTimeAmPm.copyWith(color: context.sub2Color),
          ),
          TextSpan(
            text: _time,
            style: AppTextStyles.dateTime.copyWith(color: context.sub2Color),
          ),
        ],
      ),
    );
  }
}
