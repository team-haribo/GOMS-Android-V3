package com.goms.goms_android_v2

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        createNotificationChannel()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "goms/device",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSupportedAbis" -> result.success(Build.SUPPORTED_ABIS.toList())
                else -> result.notImplemented()
            }
        }
    }

    // AndroidManifest의 default_notification_channel_id와 같은 ID로 만들어야
    // 서버가 channel_id 없이 보낸 FCM 알림이 이 채널로 들어온다.
    // 이미 있는 채널을 같은 값으로 다시 만들면 아무 일도 일어나지 않는다.
    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            "high_importance_channel",
            "GOMS 알림",
            NotificationManager.IMPORTANCE_HIGH,
        )
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)
    }
}
