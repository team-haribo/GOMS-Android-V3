import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/router/app_router.dart';
import 'package:goms/core/theme/app_theme.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_provider.dart';
import 'package:goms/core/utils/token_storage.dart';
import 'package:goms/features/map/data/kakao_map_runtime.dart';
import 'package:goms/firebase_options.dart';
import 'package:responsive_framework/responsive_framework.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await KakaoMapRuntime.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await TokenStorage.deleteAllTokens();
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
