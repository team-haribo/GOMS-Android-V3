import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/config/app_env.dart';
import 'package:goms/app/router/app_router.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/firebase_options.dart';
import 'package:responsive_framework/responsive_framework.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _bootstrapPlatformServices() async {
  try {
    await KakaoMapRuntime.instance.initialize();
  } catch (error, stackTrace) {
    debugPrint('KakaoMap bootstrap failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (error, stackTrace) {
    debugPrint('Firebase bootstrap failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const appEnvValue = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  final appEnv = AppEnv.fromValue(appEnvValue);

  await dotenv.load(fileName: appEnv.fileName);
  await _bootstrapPlatformServices();
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
