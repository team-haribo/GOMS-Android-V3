import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeDisplay extends StatefulWidget {
  final TextStyle style;
  final Color color;

  const TimeDisplay({
    super.key,
    required this.style,
    required this.color,
  });

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  late String _formattedTime;

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
    _formattedTime = DateFormat('a hh : mm : ss', 'en_US').format(DateTime.now());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedTime,
      style: widget.style.copyWith(color: widget.color),
    );
  }
}