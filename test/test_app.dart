import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:responsive_framework/responsive_framework.dart';

Widget buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, appChild) => ResponsiveBreakpoints.builder(
        child: appChild!,
        breakpoints: const [
          Breakpoint(start: 0, end: 359, name: AppBreakpoints.smallPhone),
          Breakpoint(start: 360, end: 450, name: AppBreakpoints.mobile),
          Breakpoint(start: 451, end: 800, name: AppBreakpoints.tablet),
          Breakpoint(start: 801, end: 1920, name: AppBreakpoints.desktop),
          Breakpoint(
            start: 1921,
            end: double.infinity,
            name: AppBreakpoints.largeDesktop,
          ),
        ],
      ),
      home: Scaffold(body: child),
    ),
  );
}
