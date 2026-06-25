import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

class KakaoMapRuntime {
  KakaoMapRuntime._();

  static final KakaoMapRuntime instance = KakaoMapRuntime._();
  static const MethodChannel _channel = MethodChannel('goms/device');

  bool _initialized = false;
  String? _unavailableReason;
  Future<void>? _initFuture;

  bool get isInitialized => _initialized;
  bool get isMapAvailable => _initialized;
  String? get unavailableReason => _unavailableReason;

  Future<void> initialize() => _initFuture ??= _initialize();

  Future<void> _initialize() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      _unavailableReason = '이 플랫폼에서는 카카오 지도를 지원하지 않습니다.';
      return;
    }

    if (Platform.isAndroid) {
      final abis = await _getSupportedAbis();
      final abiText = abis.isEmpty ? 'unknown' : abis.join(', ');
      debugPrint('KakaoMapRuntime Android ABIs: $abiText');

      final isX86Runtime = abis.any((abi) => abi.contains('x86'));
      if (isX86Runtime) {
        _unavailableReason =
            '현재 Android 실행 환경 ABI($abiText)에서는 kakao_map_sdk를 사용할 수 없습니다. x86/x86_64 에뮬레이터가 아닌 ARM64 실기기 또는 ARM 에뮬레이터에서 실행해주세요.';
        return;
      }
    }

    final appKey = dotenv.env['KAKAO_NATIVE_APP_KEY']?.trim() ?? '';
    if (appKey.isEmpty) {
      _unavailableReason = '카카오 네이티브 앱 키가 설정되지 않았습니다.';
      return;
    }

    try {
      await KakaoMapSdk.instance.initialize(appKey);
      _initialized = true;

      if (kDebugMode) {
        final hashKey = await KakaoMapSdk.instance.hashKey();
        debugPrint('KakaoMapRuntime hashKey: ${hashKey ?? 'unavailable'}');
      }
    } catch (error) {
      _unavailableReason = '카카오 지도 초기화에 실패했습니다. $error';
    }
  }

  Future<List<String>> _getSupportedAbis() async {
    try {
      final result =
          await _channel.invokeListMethod<String>('getSupportedAbis');
      return result ?? const <String>[];
    } catch (error) {
      debugPrint('KakaoMapRuntime ABI lookup failed: $error');
    }

    return const <String>[];
  }
}
