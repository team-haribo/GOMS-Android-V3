# Kakao Map SDK (kakao_map_sdk / com.kakao.maps.open)
#
# 네이티브 렌더 엔진(libK3fAndroid.so)이 JNI로 아래 클래스/필드를 이름으로 조회한다.
# R8(minify)가 이들을 제거하거나 리네임하면 릴리즈 빌드에서 맵 진입 시
#   java.lang.NoSuchFieldError / ClassNotFoundException
#   (예: com.kakao.vectormap.internal.MapViewHolder, RenderViewOptions.listener)
# at com.kakao.vectormap.internal.EngineHandler.nativeInit()
# 로 SIGABRT 크래시가 발생한다. 따라서 카카오 패키지 전체를 보존한다.
-keep class com.kakao.** { *; }
-keep interface com.kakao.** { *; }
-keepclassmembers class com.kakao.** { *; }
-dontwarn com.kakao.**
