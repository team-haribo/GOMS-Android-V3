import 'package:flutter/material.dart';
import 'dart:async';

class TimeDisplay extends StatefulWidget {
  final bool onTime;
  final TextStyle style;
  final Color color;

  const TimeDisplay({
    required this.onTime,
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
      setState(() {
        _updateTime();
      });
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final ampm = now.hour < 12 ? 'AM' : 'PM';
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    _formattedTime = '$ampm $hour:$minute:$second';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onTime
        ? const SizedBox.shrink()
        : Text(
      _formattedTime,
      style: widget.style.copyWith(color: widget.color),
    );
  }
}