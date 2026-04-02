import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:goms/core/config/app_env.dart';
import 'package:goms/core/router/app_router.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/firebase_options.dart';
import 'package:responsive_framework/responsive_framework.dart';

const MethodChannel _deviceChannel = MethodChannel('goms/device');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<bool> _shouldSkipFirebaseOnDebugX86Android() async {
  if (!kDebugMode || !Platform.isAndroid) {
    return false;
  }

  try {
    final abis =
        await _deviceChannel.invokeListMethod<String>('getSupportedAbis') ??
            const <String>[];
    return abis.any((abi) => abi.contains('x86'));
  } catch (_) {
    return false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const appEnvValue = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  final appEnv = AppEnv.fromValue(appEnvValue);

  await dotenv.load(fileName: appEnv.fileName);
  await KakaoMapRuntime.instance.initialize();

  final skipFirebaseOnDebugX86 = await _shouldSkipFirebaseOnDebugX86Android();
  if (skipFirebaseOnDebugX86) {
    debugPrint(
      'Skipping Firebase initialization on Android x86/x86_64 debug runtime '
      'to avoid emulator low-memory kills.',
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = switch (ref.watch(themeModeProvider)) {
      AsyncData(:final value) => value,
      _ => ThemeMode.system,
    };

    return MaterialApp.router(
      title: 'GOMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
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
      routerConfig: router,
    );
  }
}
